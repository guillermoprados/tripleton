extends Node

class_name GameManager

signal tokens_pool_depleted()
signal gold_updated(value:int)
signal points_updated(value:int)
signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)

@export var token_scene: PackedScene

@export var board:Board
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell
@export var combinator: Combinator
@export var gameplay_ui:GameplayUI

var dinasties_path : String = "res://data/dinasties/"

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
	dinasties_names = Utils.get_files_names_at_path(dinasties_path)
	__go_to_next_dinasty(0)

func _ready() -> void:
	pass

func __go_to_next_dinasty(overflown_points:int) -> void:
	dinasty_index += 1
	current_dinasty = ResourceLoader.load(dinasties_path + dinasties_names[dinasty_index])
	current_dinasty.earned_points = overflown_points	
	print("entering: "+current_dinasty.name)

func instantiate_new_token(token_data:TokenData) -> Token:
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	return token_instance

func add_gold(value:int) -> void:
	gold += value
	gold_updated.emit(gold)
	
func add_points(value:int) -> void:
	points += value
	points_updated.emit(points)
	__add_dinasty_points(value)

func __add_dinasty_points(points:int) -> void:
	current_dinasty.earned_points += points
	print(str(current_dinasty.earned_points) + "/" + str(current_dinasty.total_points))
	if current_dinasty.earned_points > current_dinasty.total_points:
		__go_to_next_dinasty(current_dinasty.total_points - current_dinasty.earned_points)

	## add a available_from_dinasty int to token data, and merge to chest or next token depending on it


func create_floating_token(token_data:TokenData) -> void:
	assert (!floating_token, "trying to create a floating token when there is already one")
	if not token_data:
		token_data = current_tokens_set.get_random_token_data()
	floating_token = instantiate_new_token(token_data)
	add_child(floating_token)
	__bind_token_events(floating_token)
	floating_token.position = spawn_token_cell.position
	spawn_token_cell.highlight(Constants.CellHighlight.VALID)
	
func discard_floating_token() -> void:
	assert (floating_token, "trying to discard a non existing token token when there is already one")
	__unbind_token_events(floating_token)
	floating_token.queue_free()
	floating_token = null

func __bind_token_events(token:Token) -> void:
	if token.type == Constants.TokenType.ACTION:
		token.action.move_from_cell_to_cell.connect(move_token_in_board)
		token.action.destroy_token_at_cell.connect(destroy_token_at_cell)
		token.action.set_to_bad_action.connect(set_bad_token_on_board)
		
func __unbind_token_events(token:Token) -> void:
	if token.type == Constants.TokenType.ACTION:
		token.action.move_from_cell_to_cell.disconnect(move_token_in_board)
		token.action.destroy_token_at_cell.disconnect(destroy_token_at_cell)
		token.action.set_to_bad_action.disconnect(set_bad_token_on_board)
		
func move_floating_token_to_cell(cell_index:Vector2) -> void:
	var pos_x =  (cell_index.y * Constants.CELL_SIZE.x) - Constants.CELL_SIZE.x / 2
	var pos_y =  (cell_index.x * Constants.CELL_SIZE.y) - Constants.CELL_SIZE.y / 2
	var token_position:Vector2 = board.position + Vector2(cell_index.y * Constants.CELL_SIZE.x, cell_index.x * Constants.CELL_SIZE.y)
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
			board.highlight_combination(combination)
		elif is_wildcard:
			board.highligh_cell(cell_index, Constants.CellHighlight.WARNING)
		else:
			board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
			
	else:
		
		floating_token.highlight(Constants.TokenHighlight.INVALID)
		board.highligh_cell(cell_index, Constants.CellHighlight.INVALID)
	
func __move_floating_action_token(cell_index:Vector2, on_board_position:Vector2):
	
	floating_token.position = on_board_position
		
	if floating_token.action.is_valid_action(cell_index, board.cell_tokens_ids):
		board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
		for cell in floating_token.action.affected_cells(cell_index, board.cell_tokens_ids):
			board.highligh_cell(cell, Constants.CellHighlight.WARNING)
		board.highligh_cell(cell_index, Constants.CellHighlight.VALID)
		floating_token.highlight(Constants.TokenHighlight.TRANSPARENT)

func move_token_in_board(cell_index_from:Vector2, cell_index_to:Vector2, tween_time:float) -> void:
	board.move_token_from_to(cell_index_from, cell_index_to, tween_time)

func destroy_token_at_cell(cell_index:Vector2) -> void:
	if board.is_cell_empty(cell_index):
		return
	
	var token:Token = board.get_token_at_cell(cell_index)
	if token.type == Constants.TokenType.ENEMY:
		set_dead_enemy(cell_index)
	elif token.type == Constants.TokenType.CHEST or token.type == Constants.TokenType.PRIZE:
		set_bad_token_on_board(cell_index)
	else:
		board.clear_token(cell_index)

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
	else:
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		floating_token = null
		create_floating_token(null)
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)	

func place_floating_token(cell_index:Vector2) -> bool:
	var placed : bool = false
	
	if floating_token.type == Constants.TokenType.ACTION:
		__execute_floating_token_action(cell_index)
	elif board.is_cell_empty(cell_index):
		__place_floating_token_at(cell_index)
		placed = true
	else:
		var cell_token:Token = board.get_token_at_cell(cell_index)
		
		if cell_token.type == Constants.TokenType.CHEST:
			open_chest(cell_token, cell_index)
		elif cell_token.type == Constants.TokenType.PRIZE and (cell_token.data as TokenPrizeData).collectable:
			collect_reward(cell_token, cell_index)
		else:
			show_message.emit("Cannot place token", Constants.MessageType.ERROR, .5); #localize
		
	return placed

func __place_floating_token_at(cell_index: Vector2) -> void:
	remove_child(floating_token)
	
	if floating_token.type == Constants.TokenType.WILDCARD:
		floating_token = __get_replace_wildcard_token(cell_index)
	elif floating_token.type == Constants.TokenType.ACTION:
		floating_token = __get_bad_movement_token()
	
	floating_token.hide() #will be deleted on players turn end
	
	var duplicated_token = instantiate_new_token(floating_token.data)
	
	__place_token_on_board(duplicated_token, cell_index)
	
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
	return instantiate_new_token(current_tokens_set.bad_token)

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
		
	var combined_token : Token = instantiate_new_token(next_token_data)

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
	
func open_chest(token:Token, cell_index: Vector2) -> void:
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	
	#remove the chest
	var chest_data: TokenChestData = token.data
	var prize_data:TokenPrizeData = chest_data.get_random_prize()
	var prize_instance:Token = instantiate_new_token(prize_data)
	replace_token_on_board(prize_instance, cell_index)
	
func collect_reward(token:Token, cell_index: Vector2) -> void:
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

func set_dead_enemy(cell_index:Vector2) -> void:
	var enemy_token: Token = board.get_token_at_cell(cell_index)
	var next_token_data: TokenData = enemy_token.data.next_token
	var grave_token:Token = instantiate_new_token(next_token_data)
	replace_token_on_board(grave_token, cell_index)

func can_place_more_tokens() -> bool:
	var board_free_cells : int = board.get_number_of_empty_cells()
	return board_free_cells > 0

func __execute_floating_token_action(cell_index:Vector2) -> void:
	if floating_token.action.is_valid_action(cell_index, board.cell_tokens_ids):
		__execute_token_action(floating_token, cell_index)
		board.clear_highlights()
	else:
		show_message.emit("Cannot invalid movement", Constants.MessageType.ERROR, .5);
	
func __execute_token_action(token:Token, cell_index:Vector2) -> void:
	assert (token.type == Constants.TokenType.ACTION, "cannot use an action on a non token action")
	token.action.execute_action(cell_index, board.cell_tokens_ids)

