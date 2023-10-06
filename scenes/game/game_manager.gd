extends Node

class_name GameManager

signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)
signal accumulated_reward_update(type:Constants.RewardType, value:int)

@export var token_scene: PackedScene
@export var board:Board
@export var game_info:GameInfo

func _ready() -> void:
	
	board.configure(game_info.rows, game_info.columns)
	set_difficulty_tokens(game_info.next_difficulty())
	
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	
	
func _on_screen_size_changed() -> void:
	var screen_size:Vector2 = get_viewport().get_visible_rect().size
	var board_size:Vector2 = board.board_size
	var board_pos:Vector2 = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	board.position = board_pos
	# if floating_token:
	#	floating_token.position = board.position
	board.clear_highlights()

func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var instance:Token = get_token_instance(token_data)
	instance.set_size(board.cell_size)
	if parent:
		parent.add_child(instance)
	instance.position = position
	return instance

func sum_rewards(type:Constants.RewardType, value:int, cell_index:Vector2) -> void:
	var cell_position:Vector2 = board.get_cell_at_position(cell_index).position
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
		
func show_game_message(message:String, type:Constants.MessageType, time:float) -> void:
	show_message.emit(message, type, time)

# list of token data
var tokens_pool: RandomResourcePool

func set_difficulty_tokens(difficulty: GameDifficulty) -> void:
	tokens_pool = RandomResourcePool.new(difficulty.items)

func get_random_token_data() -> TokenData:
	
	# Assert if list is empty
	assert(!tokens_pool.is_empty(), "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data:TokenData = tokens_pool.pop_item()
	
	# If list is empty, emit the difficulty_depleted signal
	if tokens_pool.is_empty():
		assert("next difficulty")
	
	return token_data

func get_token_instance(token_data: TokenData) -> Token:
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	return token_instance
