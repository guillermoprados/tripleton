extends Node

class_name GameManager

signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)
signal accumulated_reward_update(type:Constants.RewardType, value:int)

@export var game_config:GameConfig
@export var board:Board
@export var game_info:GameInfo
@export var token_instance_provider:TokenInstanceProvider

var token_data_provider:TokenDataProvider

func _ready():
	token_data_provider = TokenDataProvider.new(game_config)
	
	board.configure(game_info.rows, game_info.columns)
	token_instance_provider.set_difficulty_tokens(game_info.next_difficulty())
	
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	
	
func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	var board_size = board.board_size
	var board_pos = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	board.position = board_pos
	# if floating_token:
	#	floating_token.position = board.position
	board.clear_highlights()

func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var instance:Token = token_instance_provider.get_token_instance(token_data)
	instance.set_size(board.cell_size)
	if parent:
		parent.add_child(instance)
	instance.position = position
	return instance

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
		
func show_game_message(message:String, type:Constants.MessageType, time:float):
	show_message.emit(message, type, time)


