extends Node

class_name GameManager

signal tokens_pool_depleted()
signal gold_updated(value:int)
signal points_updated(updated_points:int, dinasty_points: int, total_points:int)
signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)
signal dinasty_changed(name:String, max_points:int, overflow:int)

@export var token_scene: PackedScene

@export var board:Board
@export var dinasties : DinastyMap
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell
@export var combinator: Combinator
@export var gameplay_ui:GameplayUI
@export var default_chest: TokenData # mmmmm
@export var fx_manager : FxManager

var dinasty_index : int = -1
var current_dinasty:Dinasty
var current_tokens_set: TokensSet:
	get:
		return current_dinasty.tokens
var dinasties_names:Array
		
var floating_token: Token
var saved_token: Token

var points: int
var gold: int

func _enter_tree() -> void:
	assert(dinasties, "cannot load dinasties")
	assert(default_chest, "plase set the default chest for combinations")
	
func _ready() -> void:
	# remember there is an intro state, probably you
	# want to do wharever you want to do there
	pass

func __go_to_next_dinasty(overflow:int) -> void:
	dinasty_index += 1
	current_dinasty = dinasties.ordered_dinasties[dinasty_index]
	print("change dinasty: "+str(current_dinasty.name)+" points: "+str(current_dinasty.total_points))
	current_dinasty.earned_points = overflow
	board.change_back_texture(current_dinasty.map_texture)
	dinasty_changed.emit(current_dinasty.name, current_dinasty.total_points)

func instantiate_new_token(token_data:TokenData, initial_status:Constants.TokenStatus) -> Token:
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data, initial_status)
	return token_instance

func add_gold(value:int) -> void:
	gold += value
	gold_updated.emit(gold)
	
func add_points(value:int) -> void:
	points += value
	__add_dinasty_points(value)
	points_updated.emit(value, current_dinasty.earned_points, points)
	
func __add_dinasty_points(points:int) -> void:
	current_dinasty.earned_points += points
	if current_dinasty.earned_points >= current_dinasty.total_points:
		var overflow : int = current_dinasty.earned_points - current_dinasty.total_points
		__go_to_next_dinasty(overflow)
		
func create_floating_token(token_data:TokenData) -> void:
	assert (!floating_token, "trying to create a floating token when there is already one")
	if not token_data:
		token_data = current_tokens_set.get_random_token_data()
	
	floating_token = instantiate_new_token(token_data, Constants.TokenStatus.BOXED)
	add_child(floating_token)
	floating_token.position = spawn_token_cell.position
	floating_token.z_index = Constants.FLOATING_Z_INDEX
	
	spawn_token_cell.highlight(Constants.CellHighlight.VALID)
	
func discard_floating_token() -> void:
	assert (floating_token, "trying to discard a non existing token token when there is already one")
	floating_token.queue_free()
	floating_token = null
	
func move_floating_token_to_cell(cell_index:Vector2) -> void:
	var token_position:Vector2 = board.position + board.get_cell_at_position(cell_index).position
	
	if floating_token.is_boxed:
		floating_token.set_status(Constants.TokenStatus.FLOATING)
		
	if floating_token.type == Constants.TokenType.ACTION:
		__move_floating_action_token(cell_index, token_position)
	else:	 
		__move_floating_normal_token(cell_index, token_position)

func __move_floating_normal_token(cell_index:Vector2, on_board_position:Vector2) -> void:
	
	if board.is_cell_empty(cell_index):
		
		floating_token.position = on_board_position
		floating_token.unhighlight()
		
		var is_wildcard = floating_token.type == Constants.TokenType.WILDCARD
		
		if is_wildcard:
			# this is esential to ensure the combination on that cell is 
			# being replaced with the wildcard
			__check_wildcard_combinations_at(cell_index)

		var combination:Combination = check_combination_all_levels(floating_token, cell_index)

		if combination.is_valid():
			board.highlight_combination(cell_index, combination)
		elif is_wildcard:
			board.highligh_cell(cell_index, Constants.CellHighlight.WARNING)
		else:
			board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
			
	else:
		
		floating_token.highlight(Constants.TokenHighlight.INVALID)
		board.highligh_cell(cell_index, Constants.CellHighlight.INVALID)
	
func __move_floating_action_token(cell_index:Vector2, on_board_position:Vector2):
	floating_token.position = on_board_position
	
	var action_status : Constants.ActionResult = floating_token.action.action_status_on_cell(cell_index, board.cell_tokens_ids)
		
	match action_status:
		Constants.ActionResult.VALID:
			board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
			for cell in floating_token.action.affected_cells(cell_index, board.cell_tokens_ids):
				board.highligh_cell(cell, Constants.CellHighlight.WARNING) # TODO: Replace proper visual
		Constants.ActionResult.NOT_VALID:
			board.highligh_cell(cell_index, Constants.CellHighlight.INVALID)
		Constants.ActionResult.WASTED:
			board.highligh_cell(cell_index, Constants.CellHighlight.WARNING)
	
	if board.is_cell_empty(cell_index):
		floating_token.highlight(Constants.TokenHighlight.NONE)
	else:
		floating_token.highlight(Constants.TokenHighlight.TRANSPARENT)
		
func move_floating_token_to_swap_cell() -> void:
	board.clear_highlights()
	floating_token.unhighlight()
	var swap_position:Vector2 = save_token_cell.position
	if saved_token != null:
		swap_position = swap_position - (Constants.CELL_SIZE / 3)
	floating_token.position = swap_position
	
func swap_floating_and_saved_token(cell_index: Vector2) -> void:
	if saved_token:
		var floating_pos:Vector2 = floating_token.position
		var switch_token:Token = floating_token
		floating_token = saved_token
		saved_token = switch_token
		floating_token.position = floating_pos
		saved_token.position = save_token_cell.position
		saved_token.set_status(Constants.TokenStatus.BOXED)
		floating_token.set_status(Constants.TokenStatus.FLOATING)
	else:
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		saved_token.set_status(Constants.TokenStatus.BOXED)
		floating_token = null
		create_floating_token(null)
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)	

func try_to_place_floating_token(cell_index:Vector2) -> void:
	
	assert(floating_token, "of course you need a floating token")
	
	if floating_token.type == Constants.TokenType.ACTION:
		__try_to_run_user_action(cell_index)	
	elif board.is_cell_empty(cell_index):
		__place_floating_token_at(cell_index)
	else:
		var cell_token:Token = board.get_token_at_cell(cell_index)
		if cell_token.type == Constants.TokenType.CHEST:
			__open_chest(cell_token, cell_index)
		elif cell_token.type == Constants.TokenType.PRIZE and (cell_token.data as TokenPrizeData).collectable:
			__collect_reward(cell_token, cell_index)
		else:
			show_message.emit("This is not empty", Constants.MessageType.ERROR, .5); #localize

func __try_to_run_user_action(cell_index: Vector2) -> void:
	var action_expected_result : Constants.ActionResult = floating_token.action.action_status_on_cell(cell_index, board.cell_tokens_ids)
	match action_expected_result:
		Constants.ActionResult.VALID:
			__process_user_action(floating_token.action.get_type(), cell_index)
		Constants.ActionResult.NOT_VALID:
			show_message.emit("Invalid movement", Constants.MessageType.ERROR, .5); #localize
		Constants.ActionResult.WASTED:
			set_bad_token_on_board(cell_index)
			discard_floating_token()

func __place_floating_token_at(cell_index: Vector2) -> void:
	remove_child(floating_token)
	
	if floating_token.type == Constants.TokenType.WILDCARD:
		floating_token = __get_replace_wildcard_token(cell_index)
	elif floating_token.type == Constants.TokenType.ACTION:
		floating_token = __get_bad_movement_token()
	
	var duplicated_token = instantiate_new_token(floating_token.data, Constants.TokenStatus.PLACED)
	
	__place_token_on_board(duplicated_token, cell_index)
	
	discard_floating_token()
	
func __place_token_on_board(token:Token, cell_index: Vector2) -> void:
	
	board.set_token_at_cell(token, cell_index)
	board.clear_highlights()
	assert(board.get_token_at_cell(cell_index), "placed token is empty")

	combinator.reset_combinations(board.rows, board.columns)
	check_and_do_board_combinations([cell_index], Constants.MergeType.BY_INITIAL_CELL)

func replace_token_on_board(token:Token, cell_index:Vector2) -> void:
	
	var old_token_date:float = board.get_token_at_cell(cell_index).created_at
	board.clear_token(cell_index)
	
	if token:
		board.set_token_at_cell(token, cell_index)
		token.created_at = old_token_date
	
	board.clear_highlights()

	combinator.reset_combinations(board.rows, board.columns)

func set_bad_token_on_board(cell_index:Vector2) -> void:
	var bad_token : Token = __get_bad_movement_token()
	if board.is_cell_empty(cell_index):
		__place_token_on_board(bad_token, cell_index)
	else:
		replace_token_on_board(bad_token, cell_index)

func __get_replace_wildcard_token(cell_index:Vector2) -> Token:
	var replace_token : Token = null
	var combination : Combination = combinator.get_combinations_for_cell(cell_index)
	if combination.is_valid():
		assert(combination.wildcard_evaluated , "trying to replace a combination that is not wildcard")
		replace_token = board.get_token_at_cell(combination.combinable_cells[1]) # skip the first one
	else: 
		replace_token = __get_bad_movement_token()
	
	return replace_token

func __get_bad_movement_token() -> Token:
	return instantiate_new_token(current_tokens_set.bad_token, Constants.TokenStatus.PLACED)

func check_and_do_board_combinations(cells:Array, merge_type:Constants.MergeType) -> void:
	
	var merged_cells : Array = []
	
	for cell_index in cells:
	
		# multiple cells can be part of the same combination, so we don't want 
		# to merge them again
		if cell_index in merged_cells:
			continue
			
		var token:Token = board.get_token_at_cell(cell_index)
		var combination:Combination = check_combination_single_level(token, cell_index)
		if combination.is_valid():
			var merge_position:Vector2
			if merge_type == Constants.MergeType.BY_LAST_CREATED:
				merge_position = __get_last_created_token_position(combination.combinable_cells)
			else:
				merge_position = combination.initial_cell()
			
			merged_cells.append_array(combination.combinable_cells)
			var combined_token:Token = combine_tokens(combination)
			
			__place_token_on_board(combined_token, merge_position)
			
			
func __get_last_created_token_position(cells: Array) -> Vector2:
	# Ensure the cells array is not empty.
	assert(cells.size() > 0, "Cells array is empty. Cannot get last created token.")

	var last_created_position: Vector2 = cells[0]
	var last_token = board.get_token_at_cell(last_created_position)
	var last_created_time: float = last_token.created_at

	for cell_index in cells:
		var current_token = board.get_token_at_cell(cell_index)
		var current_created_time = current_token.created_at

		# Update the latest created token details if the current token is newer.
		if current_created_time > last_created_time:
			last_created_position = cell_index
			last_created_time = current_created_time

	return last_created_position

		
func check_combination_all_levels(token:Token, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, true)

func check_combination_single_level(token:Token, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, false)

# move to board
func combine_tokens(combination: Combination) -> Token:
	
	var initial_token:Token = board.get_token_at_cell(combination.initial_cell())
	var initial_token_data:TokenCombinableData = initial_token.data
	
	var next_token_data:TokenCombinableData = initial_token_data.next_token
	
	for i in range(combination.last_level_reached):
		next_token_data = next_token_data.next_token
	
	if next_token_data.available_from_dinasty > dinasty_index:
		next_token_data = default_chest
		
	var combined_token : Token = instantiate_new_token(next_token_data, Constants.TokenStatus.PLACED)

	var awarded_points:int = 0	
	
	for cell_index in combination.combinable_cells:
		var token:Token = board.get_token_at_cell(cell_index)
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

func __check_wildcard_combinations_at(cell_index:Vector2) -> void:
	
	if combinator.get_combinations_for_cell(cell_index).wildcard_evaluated:
		return
	
	var bigger_combination: Combination = null
	var bigger_points:int
	
	var check_positions:Array[Vector2] = []
	
	# top
	if cell_index.y > 0:
		check_positions.append(Vector2(cell_index.x, cell_index.y - 1))
	# down
	if cell_index.y < board.rows - 1:
		check_positions.append(Vector2(cell_index.x, cell_index.y + 1))
	# left
	if cell_index.x > 0:
		check_positions.append(Vector2(cell_index.x - 1, cell_index.y))
	# right
	if cell_index.x < board.rows - 1:
		check_positions.append(Vector2(cell_index.x + 1, cell_index.y))
	
	for pos in check_positions:
		
		if board.is_cell_empty(pos):
			continue
					
		var copied_token = board.get_token_at_cell(pos)
		
		# this will never happen because it requires two wildcards in the board
		# .. but anyway..
		if copied_token.type == Constants.TokenType.WILDCARD:
			continue
		
		combinator.clear_evaluated_combination(cell_index)
		
		var combination : Combination = check_combination_all_levels(copied_token, cell_index)
			
		if combination.is_valid():
			var current_points:int = 0
			
			for cell in combination.combinable_cells:
				if board.is_cell_empty(cell):
					continue
				var token:Token = board.get_token_at_cell(cell)
				if token.data.reward_type == Constants.RewardType.POINTS:
					current_points += token.data.reward_value
			if current_points > bigger_points:
				bigger_points = current_points
				bigger_combination = combination
				
	if bigger_combination:
		combinator.replace_combination_at_cell(bigger_combination, cell_index)

	combinator.get_combinations_for_cell(cell_index).wildcard_evaluated = true
	
func __open_chest(token:Token, cell_index: Vector2) -> void:
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	floating_token.set_status(Constants.TokenStatus.BOXED)
	
	#remove the chest
	var chest_data: TokenChestData = token.data
	var prize_data:TokenPrizeData = chest_data.get_random_prize()
	var prize_instance:Token = instantiate_new_token(prize_data, Constants.TokenStatus.PLACED)
	replace_token_on_board(prize_instance, cell_index)
	
func __collect_reward(token:Token, cell_index: Vector2) -> void:
	var prize_data: TokenPrizeData = token.data
	show_rewards(prize_data.reward_type, prize_data.reward_value, cell_index)
	sum_rewards(prize_data.reward_type, prize_data.reward_value)
	replace_token_on_board(null, cell_index)

func show_rewards(type:Constants.RewardType, value:int, cell_index:Vector2) -> void:
	var cell_position:Vector2 = board.get_cell_at_position(cell_index).position
	var reward_position: Vector2 = board.position + cell_position
	reward_position.x += Constants.CELL_SIZE.x / 2 
	reward_position.y += Constants.CELL_SIZE.y / 4 
		
	show_floating_reward.emit(type, value, reward_position)

# used by enemies!
func move_token_in_board(cell_index_from:Vector2, cell_index_to:Vector2, tween_time:float, tween_delay:float) -> void:
	board.move_token_from_to(cell_index_from, cell_index_to, tween_time, tween_delay)

func set_dead_enemy(cell_index:Vector2) -> void:
	var enemy_token: Token = board.get_token_at_cell(cell_index)
	var next_token_data: TokenData = enemy_token.data.next_token
	var grave_token:Token = instantiate_new_token(next_token_data, Constants.TokenStatus.PLACED)
	replace_token_on_board(grave_token, cell_index)

func can_place_more_tokens() -> bool:
	var board_free_cells : int = board.get_number_of_empty_cells()
	return board_free_cells > 0

## ACTIONS
	
func __process_user_action(action_type:Constants.ActionType, cell_index:Vector2) -> void:
	
	board.enabled_interaction = false
	
	match action_type:
		Constants.ActionType.BOMB:
			__bomb_cell_action(cell_index)
		Constants.ActionType.MOVE:
			__move_token_action(cell_index)

func __bomb_cell_action(cell_index:Vector2) -> void:
	var token:Token = board.get_token_at_cell(cell_index)
	assert(token, "There is no token to bomb here")
	
	var pos:Vector2 = token.position + token.sprite_holder.position
	fx_manager.play_bomb_explosion(pos)
	
	if token.type == Constants.TokenType.ENEMY:
		set_dead_enemy(cell_index)
	elif token.type == Constants.TokenType.CHEST or token.type == Constants.TokenType.PRIZE:
		set_bad_token_on_board(cell_index)
	else:
		board.clear_token(cell_index)
	
	discard_floating_token()

var move_token_action_callables:Dictionary = {}
var move_token_origin:Vector2

func __move_token_action(cell_origin_index:Vector2) -> void:
	
	move_token_origin = cell_origin_index
	
	var move_token_cells : Array[Vector2] = floating_token.action.affected_cells(cell_origin_index, board.cell_tokens_ids) 
	
	for move_cell_index in move_token_cells:
		var cell_board = board.get_cell_at_position(move_cell_index)
		var callable : Callable = Callable(__move_token_action_cell_selected)
		cell_board.cell_selected.connect(callable)
		move_token_action_callables[move_cell_index] = callable
		fx_manager.play_select_cell_animation(cell_board.position)
		
func __move_token_action_cell_selected(to:Vector2) -> void:
	
	board.clear_highlights()
	fx_manager.stop_select_cell_anims()
	
	move_token_in_board(move_token_origin, to, 0.2, 0)
	
	for cell in move_token_action_callables.keys():
		board.get_cell_at_position(cell).cell_selected.disconnect(move_token_action_callables[cell])
	move_token_action_callables.clear()
	
	discard_floating_token()
