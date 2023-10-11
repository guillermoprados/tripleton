extends Node

class_name GameManager

signal gold_updated(value:int)
signal points_updated(value:int)

@export var token_scene: PackedScene
@export var board:Board
@export var level_config:LevelConfig

@export var gameplay_ui:GameplayUI

var points: int
var gold: int

# list of token data
var tokens_pool: RandomResourcePool

func _ready() -> void:
	set_difficulty_tokens(next_difficulty())
	
func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var token:Token = get_token_instance(token_data)
	if parent:
		parent.add_child(token)
	token.position = position
	return token


func set_difficulty_tokens(difficulty: GameDifficulty) -> void:
	tokens_pool = RandomResourcePool.new(difficulty.items)

func get_random_token_data() -> TokenData:
	
	# Assert if list is empty
	assert(!tokens_pool.is_empty(), "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data:TokenData = tokens_pool.pop_item()
	
	# If list is empty, emit the difficulty_depleted signal
	if tokens_pool.is_empty():
		assert( false, "next difficulty")
	
	return token_data

func get_token_instance(token_data: TokenData) -> Token:
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	return token_instance

func next_difficulty() -> GameDifficulty:
	return level_config.difficulties[0] 

func add_gold(value:int) -> void:
	gold += value
	gold_updated.emit(gold)
	
func add_points(value:int) -> void:
	points += value
	points_updated.emit(points)
