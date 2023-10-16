extends Node

class_name GameManager

signal gold_updated(value:int)
signal points_updated(value:int)
signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)

@export var token_scene: PackedScene

@export var board:Board
@export var level_config:LevelConfig
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell

@export var combinator: Combinator

@export var gameplay_ui:GameplayUI


var floating_token: Token
var saved_token: Token

var points: int
var gold: int

# list of token data
var tokens_pool: RandomResourcePool

func _ready() -> void:
	tokens_pool = RandomResourcePool.new()
	level_config.validate()
	pass

func __set_next_tokens_set(config:LevelConfig) -> void:
	
	var _tokens_set: TokensSet
	if level_config.tokens_sets.size() > 1:
		_tokens_set = level_config.tokens_sets.pop_front()
	else:
		_tokens_set = level_config.tokens_sets[0]
		print(">> We ran out of token sets.. gonna need to repeat the last one "+_tokens_set.name)
		
	tokens_pool.add_items(_tokens_set.items, true)	
		
func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	if parent:
		parent.add_child(token_instance)
	token_instance.position = position
	return token_instance

func __get_random_token_data() -> TokenData:
	
	# If list is empty, emit the difficulty_depleted signal
	# im gonna fix this later to make this more lindo
	if tokens_pool.is_empty():
		__set_next_tokens_set(level_config)
		
	# Assert if list is empty
	assert(!tokens_pool.is_empty(), "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data:TokenData = tokens_pool.pop_item()
	
	return token_data

func add_gold(value:int) -> void:
	gold += value
	gold_updated.emit(gold)
	
func add_points(value:int) -> void:
	points += value
	points_updated.emit(points)

func create_floating_token() -> void:
	assert (!floating_token, "trying to create a floating token when there is already one")
	var random_token_data:TokenData = __get_random_token_data()
	floating_token = instantiate_new_token(random_token_data, spawn_token_cell.position, self)
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)

func move_floating_token_to_cell(cell_index:Vector2) -> void:
	var token_position:Vector2 = board.position + Vector2(cell_index.y * Constants.CELL_SIZE.x, cell_index.x * Constants.CELL_SIZE.y)
	floating_token.position = token_position
	
	if floating_token.type == Constants.TokenType.WILDCARD:
		# this is esential to ensure the combination on that cell is 
		# being replaced with the wildcard
		__check_wildcard_combinations_at(cell_index)
	
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
		create_floating_token()
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)	

func __replace_wildcard_token(old_token:Token, cell_index:Vector2) -> Token:
	var replace_token : Token = null
	var combination : Combination = combinator.get_combinations_for_cell(cell_index)
	assert(combination.wildcard_evaluated , "trying to replace a combination that is not wildcard")
	if combination.is_valid():
		replace_token = board.get_token_at_cell(combination.combinable_cells[1]) # skip the first one
	else: 
		var next_token_data: TokenData = old_token.data.next_token
		replace_token = instantiate_new_token(next_token_data, floating_token.position, null)
	
	return replace_token
		
func place_token_on_board(token:Token, cell_index: Vector2) -> void:
	if token.type == Constants.TokenType.WILDCARD:
		token = __replace_wildcard_token(token, cell_index)

	board.set_token_at_cell(token, cell_index)
	board.clear_highlights()

	assert(board.get_token_at_cell(cell_index), "placed token is empty")

	combinator.reset_combinations(board.rows, board.columns)
	var combination:Combination = check_combination_single_level(token, cell_index)
	if combination.is_valid():
		var combined_token:Token = combine_tokens(combination)
		place_token_on_board(combined_token, combination.cell_index)


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
		
	var combined_token : Token = instantiate_new_token(next_token_data, Vector2.ZERO, null)

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
		print("already evaluated")
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
				bigger_combination = combination

	if bigger_combination:
		combinator.replace_combination_at_cell(bigger_combination, cell_index)

	combinator.get_combinations_for_cell(cell_index).wildcard_evaluated = true
	
func open_chest(token:Token, cell_index: Vector2) -> void:
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	
	#remove the chest
	board.clear_token(cell_index)
	var chest_data: TokenChestData = token.data
	var prize_data:TokenPrizeData = chest_data.get_random_prize()
	var prize_instance:Token = instantiate_new_token(prize_data, Vector2.ZERO, null)
	place_token_on_board(prize_instance, cell_index)
	
func collect_reward(token:Token, cell_index: Vector2) -> void:
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

