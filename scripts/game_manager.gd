extends Node

class_name GameManager

signal gold_added(added_gold:int, game_gold:int)
signal points_added(added_points:int, difficulty_points:int, game_points:int)
signal difficulty_changed(name:String, total_points:int)
signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)

@export var game_config_data: GameConfigData

@export_category("Managers")
@export var fx_manager : FxManager
@export var combinator: Combinator

@export_category("Packed Scenes")
@export var token_scene: PackedScene
@export var cell_scene: PackedScene
@export var save_token_slot_scene: PackedScene

@export_category("Game Elements")
@export var board:Board
@export var gameplay_ui:GameplayUI
@export var initial_token_slot:InitialTokenSlot 

@export_category("Required but gonna change later")
@export var bad_token_data: TokenData # mmmmm
@export var grave_token_data: TokenData # mmmmm
@export var to_test: TokenData # mmmmm

var __game_points: int
var game_points:int:
	get:
		return __game_points

var __game_gold: int
var game_gold:int:
	get:
		return __game_gold

var __difficulty_index : int = -1
var __difficulties : Array[Difficulty]

var __difficulty_points: int
var difficulty_points:int:
	get:
		return __difficulty_points
		
var difficulty: Difficulty:
	get:
		return __difficulties[__difficulty_index]

var __floating_token: BoardToken = null
var floating_token: BoardToken:
	get:
		return __floating_token
	set(value):
		assert(not __floating_token, "there is a ft already")
		assert(not value.get_parent(), "cannot set a parented token")
		__floating_token = value
		add_child(floating_token)
		floating_token.z_index = Constants.FLOATING_Z_INDEX
		floating_token.set_status(Constants.TokenStatus.FLOATING)
		
var __save_slots:Array[SaveTokenSlot] = []
var save_slots:Array[SaveTokenSlot]:
	get:
		return __save_slots


func _enter_tree() -> void:
	assert(fx_manager, "plase set the fx manager")
	assert(combinator, "please set the combinator")

func _ready() -> void:
	pass
	
func connect_ui() -> void:
	pass

## Difficulty
func __set_difficulties(diffs:Array[Difficulty]) -> void:
	__difficulties = diffs
	__next_difficulty()
	
func __next_difficulty() -> void:
	__difficulty_index += 1
	var required_slots := difficulty.save_token_slots 
	while save_slots.size() < required_slots:
		var save_token_slot : SaveTokenSlot = save_token_slot_scene.instantiate() as SaveTokenSlot
		save_token_slot.index = save_slots.size()
		save_slots.append(save_token_slot)
		add_child(save_token_slot)
		save_token_slot.enabled = true
		__adjust_save_token_slots_positions()
	board.change_back_texture(difficulty.map_texture)
	difficulty_changed.emit(difficulty.name, difficulty.total_points)	
	
func instantiate_new_token(token_id:String, initial_status:Constants.TokenStatus) -> BoardToken:
	var token_instance: BoardToken = token_scene.instantiate() as BoardToken
	token_instance.set_data(token_id, initial_status)
	return token_instance

func add_gold(value:int) -> void:
	__game_gold += value
	gold_added.emit(value, game_gold)
	
func add_points(value:int) -> void:
	__game_points += value
	__difficulty_points += value
	if __difficulty_points >= difficulty.total_points and __difficulty_index < __difficulties.size() - 1:
		var overflow : int = __difficulty_points - difficulty.total_points
		__next_difficulty()
		__difficulty_points = overflow
	points_added.emit(value, __difficulty_points, game_points)

func pick_up_floating_token() -> void:
	floating_token = initial_token_slot.pick_token()
	floating_token.position = initial_token_slot.position
	
func release_floating_token() -> BoardToken:
	assert(floating_token.get_parent() == self, "we're not the parent of this token")
	var released_token := floating_token
	var token_world_pos := floating_token.position
	remove_child(floating_token)
	__floating_token = null
	return released_token
		
func spawn_new_token(token_id:String='') -> void:
	if token_id == '':
		token_id = difficulty.get_random_token_data_id()
	initial_token_slot.spawn_token(token_id)
	
func discard_floating_token() -> void:
	assert (floating_token, "trying to discard a non existing token")
	remove_child(floating_token)
	floating_token.queue_free()
	__floating_token = null

func reset_floating_token_to_initial_box() -> void:
	assert(floating_token, "cannot return an empty token")
	var world_pos := floating_token.global_position
	initial_token_slot.return_token(release_floating_token(), world_pos)
			
func move_floating_token_to_cell(cell_index:Vector2) -> void:
	
	board.clear_highlights()
	var token_position:Vector2 = board.position + board.get_cell_at_position(cell_index).position

	if floating_token.type == Constants.TokenType.ACTION:
		__move_floating_action_token(cell_index, token_position)
	else:	 
		__move_floating_normal_token(cell_index, token_position)

func __move_floating_normal_token(cell_index:Vector2, on_board_position:Vector2) -> void:
	
	if board.is_cell_empty(cell_index):
		
		floating_token.position = on_board_position
		floating_token.unhighlight()
		
		var combination:Combination = check_combination_all_levels(floating_token, cell_index)

		if combination.is_valid():
			board.highlight_combination(cell_index, combination)
			floating_token.set_highlight(Constants.TokenHighlight.COMBINATION)
		else:
			board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
			floating_token.set_highlight(Constants.TokenHighlight.NONE)
	else:
		
		floating_token.set_highlight(Constants.TokenHighlight.INVALID)
		board.highligh_cell(cell_index, Constants.CellHighlight.INVALID)
	
func __move_floating_action_token(cell_index:Vector2, on_board_position:Vector2) -> void:
	floating_token.position = on_board_position
	
	var action_status : Constants.ActionResult = floating_token.action.action_check_result_on_cell(cell_index, board.cell_tokens_ids)
	
	match action_status:
		Constants.ActionResult.VALID:
			var action_cells : Array[Vector2] = floating_token.action.affected_cells(cell_index, board.cell_tokens_ids) 
			if floating_token.is_wildcard:
				var wildcard_action : ActionWildcard = (floating_token.action as ActionWildcard)
				board.highlight_combination(cell_index, wildcard_action.get_wildcard_combination())
				var to_place_id : String = wildcard_action.get_to_place_token_id()
				var to_place_token : BoardToken = instantiate_new_token(to_place_id, Constants.TokenStatus.PLACED)
				wildcard_action.set_ghost_token(to_place_token)
				board.highligh_cell(cell_index, Constants.CellHighlight.COMBINATION)
			else:
				board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
				## if there are more affected cells by the action, highlight : TODO: CHANGE COLOR
				for affected_cell in action_cells:
					if affected_cell != cell_index:
						board.highligh_cell(affected_cell, Constants.CellHighlight.COMBINATION)
			
			floating_token.set_highlight(Constants.TokenHighlight.VALID)
			
		Constants.ActionResult.INVALID:
			board.highligh_cell(cell_index, Constants.CellHighlight.INVALID)
			floating_token.set_highlight(Constants.TokenHighlight.INVALID)
		Constants.ActionResult.WASTED:
			board.highligh_cell(cell_index, Constants.CellHighlight.WASTED)
			floating_token.set_highlight(Constants.TokenHighlight.WASTED)
		
		
func process_cell_selection(cell_index:Vector2) -> void:
	
	var processed : bool = false
	
	board.enabled_interaction = false
	
	if not processed:
		processed = __process_chest_or_prize_selection(cell_index)
	
	if not processed:
		if floating_token.type == Constants.TokenType.ACTION:
			processed = __process_user_action(cell_index)
		else:
			processed = __place_floating_token_at(cell_index)
	
	if not processed:
		board.enabled_interaction = true
	
func __process_chest_or_prize_selection(cell_index:Vector2) -> bool:
	var processed := false
	
	if not board.is_cell_empty(cell_index):
	
		var cell_token:BoardToken = board.get_token_at_cell(cell_index)
		
		var picked_action := false
		
		if cell_token.type == Constants.TokenType.CHEST:
			__open_chest(cell_token, cell_index)
			picked_action = true
		elif cell_token.type == Constants.TokenType.PRIZE and (cell_token.data as TokenPrizeData).is_collectable:
			__collect_reward(cell_token, cell_index)
			picked_action = true
		
		if picked_action:
			if floating_token:
				reset_floating_token_to_initial_box()
			board.clear_highlights()
			board.enabled_interaction = true
			processed = true
	
	return processed
	
func __process_user_action(cell_index: Vector2) -> bool:
	
	var processed := false
	
	var action_expected_result : Constants.ActionResult = floating_token.action.action_check_result_on_cell(cell_index, board.cell_tokens_ids)
	
	match action_expected_result:
		Constants.ActionResult.VALID:
			
			var clear_highlights := true
			match floating_token.action.get_type():
				Constants.ActionType.BOMB:
					__bomb_cell_action(cell_index)
				Constants.ActionType.MOVE:
					__move_token_action(cell_index)
					clear_highlights = false
				Constants.ActionType.WILDCARD:
					__place_wildcard_cell_action(cell_index)
				Constants.ActionType.LEVEL_UP:
					__level_up_cell_action(cell_index)
				Constants.ActionType.REMOVE_ALL:
					__remove_all_type_action(cell_index)
			
			if clear_highlights:
				board.clear_highlights()
				
			processed = true
			
		Constants.ActionResult.INVALID:
			show_message.emit("Invalid movement", Constants.MessageType.ERROR, .5); #localize
			processed = false
		Constants.ActionResult.WASTED:
			set_bad_token_on_board(cell_index)
			discard_floating_token()
			processed = true
			
	return processed
	
func __place_floating_token_at(cell_index: Vector2) -> bool:
	
	var processed := true
	
	if board.is_cell_empty(cell_index):
		var duplicated_token := instantiate_new_token(floating_token.data.id, Constants.TokenStatus.PLACED)
		__place_token_on_board(duplicated_token, cell_index)
		discard_floating_token()
		processed = true
	else:
		show_message.emit("cannot place a token there", Constants.MessageType.ERROR, .5); #localize
		processed = false
	
	return processed
	
func __place_token_on_board(token:BoardToken, cell_index: Vector2) -> void:
	
	board.set_token_at_cell(token, cell_index)
	board.clear_highlights()
	assert(board.get_token_at_cell(cell_index), "placed token is empty")

	combinator.reset_combinations(board.rows, board.columns)
	check_and_do_board_combinations([cell_index], Constants.MergeType.BY_INITIAL_CELL)

# replace SHOULD NOT check combinations!! if you need to check after replace, call it manually
func __replace_token_on_board(token:BoardToken, cell_index:Vector2) -> void:
	
	# it's important to keep the time, because when merging graves it merges to the last one
	var old_token_date:float = board.get_token_at_cell(cell_index).created_at
	board.clear_token(cell_index)
	token.created_at = old_token_date
	board.set_token_at_cell(token, cell_index)
	board.clear_highlights()

func set_bad_token_on_board(cell_index:Vector2) -> void:
	var bad_token := instantiate_new_token(bad_token_data.id, Constants.TokenStatus.PLACED)
	if board.is_cell_empty(cell_index):
		__place_token_on_board(bad_token, cell_index)
	else:
		__replace_token_on_board(bad_token, cell_index)

func __get_replace_wildcard_token_data(cell_index:Vector2) -> TokenData:
	var replace_token : BoardToken = null
	var combination : Combination = combinator.get_combinations_for_cell(cell_index)
	if combination.is_valid():
		assert(combination.wildcard_evaluated , "trying to replace a combination that is not wildcard")
		return board.get_token_at_cell(combination.combinable_cells[1]).data # skip the first one
	else: 
		return bad_token_data

func check_and_do_board_combinations(cells:Array, merge_type:Constants.MergeType) -> void:
	
	var merged_cells : Array = []
	
	for cell_index:Vector2 in cells:
	
		# multiple cells can be part of the same combination, so we don't want 
		# to merge them again
		if cell_index in merged_cells:
			continue
			
		var token:BoardToken = board.get_token_at_cell(cell_index)
		var combination:Combination = check_combination_single_level(token, cell_index)
		if combination.is_valid():
			var merge_position:Vector2
			if merge_type == Constants.MergeType.BY_LAST_CREATED:
				merge_position = __get_last_created_token_position(combination.combinable_cells)
			else:
				merge_position = combination.initial_cell()
			
			merged_cells.append_array(combination.combinable_cells)
			var combined_token:BoardToken = combine_tokens(combination)
			
			__place_token_on_board(combined_token, merge_position)
			
			
func __get_last_created_token_position(cells: Array) -> Vector2:
	# Ensure the cells array is not empty.
	assert(cells.size() > 0, "Cells array is empty. Cannot get last created token.")

	var last_created_position: Vector2 = cells[0]
	var last_token := board.get_token_at_cell(last_created_position)
	var last_created_time: float = last_token.created_at

	for cell_index:Vector2 in cells:
		var current_token := board.get_token_at_cell(cell_index)
		var current_created_time := current_token.created_at

		# Update the latest created token details if the current token is newer.
		if current_created_time > last_created_time:
			last_created_position = cell_index
			last_created_time = current_created_time

	return last_created_position

		
func check_combination_all_levels(token:BoardToken, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, true)

func check_combination_single_level(token:BoardToken, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, false)

# move to board
func combine_tokens(combination: Combination) -> BoardToken:
	
	var initial_token:BoardToken = board.get_token_at_cell(combination.initial_cell())
	var initial_token_data:TokenCombinableData = initial_token.data
	
	var next_token_id := initial_token_data.next_token_id
	var next_token_data:TokenCombinableData = game_config_data.get_token_data_by_id(next_token_id)
	
	# go to the last level
	for i in range(combination.last_level_reached):
		next_token_id = next_token_data.next_token_id
		next_token_data = game_config_data.get_token_data_by_id(next_token_id)
	
	var is_chest_combination := initial_token.type == Constants.TokenType.CHEST
		
	if next_token_data.level > difficulty.max_level_token and not is_chest_combination:
		next_token_data = difficulty.max_level_chest
		
	var combined_token : BoardToken = instantiate_new_token(next_token_data.id, Constants.TokenStatus.PLACED)

	var awarded_points:int = 0	
	
	for cell_index:Vector2 in combination.combinable_cells:
		var token:BoardToken = board.get_token_at_cell(cell_index)
		if token.data.reward_type == Constants.RewardType.GOLD:
			assert("Please do not reward with gold in combinations")
			# awarded_gold += token.data.reward_value
		elif token.data.reward_type == Constants.RewardType.POINTS:
			awarded_points += token.data.reward_value
			show_rewards(token.data.reward_type, token.data.reward_value, cell_index)
		board.clear_token(cell_index)
	
	if awarded_points > 0:
		sum_rewards(Constants.RewardType.POINTS, awarded_points)
		
	return combined_token

func sum_rewards(type:Constants.RewardType, value:int) -> void:
	if type == Constants.RewardType.GOLD:
		add_gold(value)
	elif type == Constants.RewardType.POINTS:
		add_points(value)
	else:
		assert( false, "what are you trying to add??")	
	
func __open_chest(token:BoardToken, cell_index: Vector2) -> void:
	#remove the chest
	var chest_data: TokenChestData = token.data
	var random_prize_id:String = chest_data.get_random_prize_id()
	var prize_data:TokenPrizeData = game_config_data.get_token_data_by_id(random_prize_id)
	var prize_instance:BoardToken = instantiate_new_token(prize_data.id, Constants.TokenStatus.PLACED)
	__replace_token_on_board(prize_instance, cell_index)
	
func __collect_reward(token:BoardToken, cell_index: Vector2) -> void:
	var prize_data: TokenPrizeData = token.data
	show_rewards(prize_data.reward_type, prize_data.reward_value, cell_index)
	sum_rewards(prize_data.reward_type, prize_data.reward_value)
	board.clear_token(cell_index)

func show_rewards(type:Constants.RewardType, value:int, cell_index:Vector2) -> void:
	var cell_position:Vector2 = board.get_cell_at_position(cell_index).position
	var reward_position: Vector2 = board.position + cell_position
	reward_position.x += Constants.CELL_SIZE.x / 2 
	reward_position.y += Constants.CELL_SIZE.y / 4 
		
	show_floating_reward.emit(type, value, reward_position)

func move_token_in_board(cell_index_from:Vector2, cell_index_to:Vector2, tween_time:float, tween_delay:float) -> void:
	board.move_token_from_to(cell_index_from, cell_index_to, tween_time, tween_delay)

func can_place_more_tokens() -> bool:
	var board_free_cells : int = board.get_number_of_empty_cells()
	return board_free_cells > 0

## Save Slots

func on_save_token_slot_entered(index:int) -> void:
	board.clear_highlights()
	if not floating_token:
		pick_up_floating_token()
		
	floating_token.unhighlight()
	floating_token.position = save_slots[index].position
	if not save_slots[index].is_empty():
		floating_token.position -= Constants.SAVE_SLOT_OVER_POS

func on_save_token_slot_selected(index:int) -> void:
	
	if not floating_token:
		pick_up_floating_token()
	
	if save_slots[index].is_empty():
		save_slots[index].save_token(release_floating_token())
		spawn_new_token()
	else:
		floating_token = save_slots[index].swap_token(release_floating_token())
		floating_token.position = save_slots[index].position - Constants.SAVE_SLOT_OVER_POS
		initial_token_slot.set_boxed_token_back(floating_token)
	
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)	

## Enemies
func set_dead_enemy(cell_index:Vector2) -> void:
	var enemy_token: BoardToken = board.get_token_at_cell(cell_index)
	var grave_token:BoardToken = instantiate_new_token(enemy_token.data.next_token_id, Constants.TokenStatus.PLACED)
	__replace_token_on_board(grave_token, cell_index)

func check_enclosed_enemies_and_kill_them() -> void:
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)
	for stucked_cell in stucked_enemies:
		set_dead_enemy(stucked_cell)
	
	var graves:Array = board.get_tokens_with_id(grave_token_data.id).keys()
	combinator.reset_combinations(board.rows, board.columns)
	check_and_do_board_combinations(graves, Constants.MergeType.BY_LAST_CREATED)

## ACTIONS

func __bomb_cell_action(cell_index:Vector2) -> void:
	var token:BoardToken = board.get_token_at_cell(cell_index)
	assert(token, "There is no token to bomb here")
	
	var pos:Vector2 = token.position + token.sprite_holder.position
	fx_manager.play_bomb_explosion(pos)
	
	if token.type == Constants.TokenType.ENEMY:
		set_dead_enemy(cell_index)
	else:
		board.clear_token(cell_index)
	
	discard_floating_token()

func __level_up_cell_action(cell_index:Vector2) -> void:
	var token:BoardToken = board.get_token_at_cell(cell_index)
	assert(token.data is TokenCombinableData, "This token type cannot be leveled")
	var token_data: TokenCombinableData = token.data as TokenCombinableData
	assert(token_data.has_next_token(), "This token cannot be leveled anymore")
	
	board.clear_token(cell_index)
	var to_place_token : BoardToken = instantiate_new_token(token_data.next_token_id, Constants.TokenStatus.PLACED)
	discard_floating_token()
	floating_token = to_place_token
	__place_floating_token_at(cell_index)
	
func __remove_all_type_action(cell_index:Vector2) -> void:
	var token:BoardToken = board.get_token_at_cell(cell_index)
	var token_data: TokenCombinableData = token.data as TokenCombinableData
	var affected_cells : Array[Vector2] = floating_token.action.affected_cells(cell_index, board.cell_tokens_ids) 
	for cell in affected_cells:
		if token.type == Constants.TokenType.ENEMY:
			set_dead_enemy(cell)
		else:
			board.clear_token(cell)
	
	discard_floating_token()
	
var move_token_action_callables:Dictionary = {}
var move_token_origin:Vector2

func __move_token_action(cell_origin_index:Vector2) -> void:
	
	move_token_origin = cell_origin_index
	
	var move_token_cells : Array[Vector2] = floating_token.action.affected_cells(cell_origin_index, board.cell_tokens_ids) 
	board.highlight_cells(move_token_cells, Constants.CellHighlight.VALID)
	
	for slot in save_slots:
		slot.enabled = false
	
	for move_cell_index in move_token_cells:
		var cell_board := board.get_cell_at_position(move_cell_index)
		var callable : Callable = Callable(__move_token_action_cell_selected)
		cell_board.cell_selected.connect(callable)
		cell_board.set_highlight(Constants.CellHighlight.COMBINATION)
		move_token_action_callables[move_cell_index] = callable
		fx_manager.play_select_cell_animation(cell_board.position)
		
func __move_token_action_cell_selected(to:Vector2) -> void:
	
	board.clear_highlights()
	board.enabled_interaction = false
	
	fx_manager.stop_select_cell_anims()
	var move_time:float = 0.2
	move_token_in_board(move_token_origin, to, move_time, 0)
	
	for cell:Vector2 in move_token_action_callables.keys():
		board.get_cell_at_position(cell).cell_selected.disconnect(move_token_action_callables[cell])
	move_token_action_callables.clear()
	
	await get_tree().create_timer(move_time).timeout
	# I need to trigger all the combination validations ofte
	combinator.reset_combinations(board.rows, board.columns)
	check_and_do_board_combinations([to], Constants.MergeType.BY_INITIAL_CELL)

	discard_floating_token()
	
func __place_wildcard_cell_action(cell_index:Vector2) -> void:
	var wildcard_action : ActionWildcard = (floating_token.action as ActionWildcard)
	var to_place_token : BoardToken = instantiate_new_token(wildcard_action.get_to_place_token_id(), Constants.TokenStatus.PLACED)
	discard_floating_token()
	floating_token = to_place_token
	__place_floating_token_at(cell_index)

### Game UI Objects

func __adjust_board_position() -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var board_size: Vector2 = Vector2(board.columns * Constants.CELL_SIZE.x, board.rows * Constants.CELL_SIZE.y)
	
	board.position.x = (screen_size.x / 2 ) - (board_size.x / 2)
	board.position.y = screen_size.y  - board_size.y - Constants.BOARD_BOTTOM_SEPARATION

func __adjust_initial_slot_position() -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	initial_token_slot.position.x = screen_size.x/2
	initial_token_slot.position.y = board.position.y - (Constants.CELL_SIZE.y/2) - Constants.INITAL_TOKEN_SLOT_SEPARATION

func __adjust_save_token_slots_positions() -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var num_of_slots := save_slots.size()
	var slots_total_width := (Constants.CELL_SIZE.x * num_of_slots) + \
							Constants.SAVE_SLOT_INTER_SEPARATION * (num_of_slots - 1)
	
	var slot_pos : Vector2
	slot_pos.x = (screen_size.x/2) - (slots_total_width/2) + (Constants.CELL_SIZE.x / 2)
	slot_pos.y = screen_size.y - Constants.SAVE_SLOT_BOTTOM_SEPARATION - (Constants.CELL_SIZE.y / 2)
	for i in range(save_slots.size()):
		save_slots[i].position = slot_pos
		save_slots[i].z_index = Constants.TOKEN_BOX_Z_INDEX 
		slot_pos.x += Constants.CELL_SIZE.x + Constants.SAVE_SLOT_INTER_SEPARATION
