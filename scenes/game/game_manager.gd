extends Node

class_name GameManager

var floating_token: Token
var saved_token: Token

signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)
signal accumulated_reward_update(type:Constants.RewardType, value:int)

@export var game_config:GameConfig
@export var board:Board
@export var game_info:GameInfo
@export var token_instance_provider:TokenInstanceProvider
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell
@export var combinator: Combinator
@export var state_machine: StateMachine

var token_data_provider:TokenDataProvider

var current_cell_index: Vector2

func _ready():
	token_data_provider = TokenDataProvider.new(game_config)
	
	board.configure(game_info.rows, game_info.columns)
	
	save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	combinator.reset_combinations(board.rows, board.columns)
	
	token_instance_provider.set_difficulty_tokens(game_info.next_difficulty())
	
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	
	create_floating_token()
	
func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	var board_size = board.board_size
	var board_pos = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	board.position = board_pos
	if floating_token:
		floating_token.position = board.position
	board.clear_highlights()

func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var instance:Token = token_instance_provider.get_token_instance(token_data)
	instance.set_size(board.cell_size)
	if parent:
		parent.add_child(instance)
	instance.position = position
	return instance

func create_floating_token():
	var random_token_data = token_instance_provider.get_random_token_data()
	floating_token = instantiate_new_token(random_token_data, spawn_token_cell.position, self)
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	
func _on_board_board_cell_moved(index:Vector2):
	current_cell_index = index
	spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size = board.cell_size
	if board.is_cell_empty(index):
		var token_position = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		floating_token.position = token_position
		var combination:Combination = __check_recursive_combination(floating_token.id, current_cell_index)
		if combination.is_valid():
			__highlight_combination(combination)
		
func _on_board_board_cell_selected(index:Vector2):
	if board.is_cell_empty(index):
		remove_child(floating_token)
		place_token_at_cell(floating_token, index)
		create_floating_token()
	else:
		var cell_token:Token = board.get_token_at_cell(index)
		if token_data_provider.token_is_chest(cell_token.id):
			open_chest(cell_token, index)
		elif token_data_provider.token_is_prize(cell_token.id):
			collect_reward(cell_token, index)
		else:
			show_message.emit("Cannot place token", Constants.MessageType.ERROR, .5); #localize

func place_token_at_cell(token:Token, cell_index: Vector2):
	assert(token, "trying to set a null token")
	combinator.reset_combinations(board.rows, board.columns)
	board.set_token_at_cell(token, cell_index)
	assert(board.get_token_at_cell(cell_index), "placed token is empty")
	board.clear_highlights()
	var combination:Combination = check_single_combination(token.id, cell_index)
	if combination.is_valid():
		var combined_token = combine_tokens(combination)
		place_token_at_cell(combined_token, combination.cell_index)
	
func open_chest(token:Token, cell_index: Vector2):
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	#remove the chest
	board.clear_token(cell_index)
	
	var chest: TokenChest = token_data_provider.get_chest(token.id)
	var prize_data: TokenData = chest.get_random_prize()
	var prize_instance = instantiate_new_token(prize_data, Vector2.ZERO, null)
	place_token_at_cell(prize_instance, cell_index)
	
func collect_reward(token:Token, cell_index: Vector2):
	var prize: TokenData = token_data_provider.token_data_by_token_id[token.id]
	sum_rewards(prize.reward_type, prize.reward_value, cell_index)
	board.clear_token(cell_index)	

func _on_save_token_cell_entered(cell_index: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_index: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_index: Vector2):
	__swap_floating_token(cell_index)

func __swap_floating_token(cell_index: Vector2):
	if saved_token:
		var floating_pos = floating_token.position
		var switch_token = floating_token
		floating_token = saved_token
		saved_token = switch_token
		floating_token.position = floating_pos
		saved_token.position = save_token_cell.position
	else:
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		create_floating_token()
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)
	
func __check_recursive_combination(tokenId, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(tokenId, cell_index, board.cell_tokens_ids, true, token_data_provider)

func check_single_combination(tokenId, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(tokenId, cell_index, board.cell_tokens_ids, false, token_data_provider)

func __highlight_combination(combination:Combination):
	for cell_index in combination.combinable_cells:
		board.get_cell_at_position(cell_index).highlight(Constants.HighlightMode.COMBINATION, true)
		
func combine_tokens(combination: Combination) -> Token:
	
	var base_token_id:String = board.get_token_at_cell(combination.initial_cell()).id
	
	var next_token_data:TokenData
	if token_data_provider.token_has_next_level(base_token_id):
		next_token_data = token_data_provider.get_next_level_data(base_token_id)
	else:
		next_token_data = token_data_provider.get_prize_for_token_combination(base_token_id)
	
	var combined_token : Token = instantiate_new_token(next_token_data, Vector2.ZERO, null)
	
	for cell_index in combination.combinable_cells:
		var token_id:String = board.get_token_at_cell(cell_index).id
		var token_data: TokenData = token_data_provider.token_data_by_token_id[token_id]
		
		sum_rewards(token_data.reward_type, token_data.reward_value, cell_index)
		board.clear_token(cell_index)
					
	return combined_token

func sum_rewards(type:Constants.RewardType, value:int, cell_index:Vector2):
	var cell_position = board.get_cell_at_position(cell_index).position
	var reward_position: Vector2 = board.position + cell_position
	reward_position.x += board.cell_size.x / 2 
	reward_position.y += board.cell_size.y / 4 
		
	show_floating_reward.emit(type, value, reward_position)
		
	if type == Constants.RewardType.GOLD:
		game_info.gold += value
		accumulated_reward_update.emit(type, game_info.gold)
	elif type == Constants.RewardType.POINTS:
		game_info.points += value
		accumulated_reward_update.emit(type, game_info.points)
	else: 
		assert("trying to add 0 points??")
