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
	pass
	
func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var token:Token = get_token_instance(token_data)
	if parent:
		parent.add_child(token)
	token.position = position
	return token


func set_tokens_set(token_set: TokensSet) -> void:
	tokens_pool = RandomResourcePool.new(token_set.items)

func next_set() -> TokensSet:
	return level_config.tokens_sets.pop_front()
	
func get_random_token_data() -> TokenData:
	
	# If list is empty, emit the difficulty_depleted signal
	# im gonna fix this later to make this more lindo
	if not tokens_pool || tokens_pool.is_empty():
		set_tokens_set(next_set())
		
	# Assert if list is empty
	assert(!tokens_pool.is_empty(), "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data:TokenData = tokens_pool.pop_item()
	
	return token_data

func get_token_instance(token_data: TokenData) -> Token:
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	return token_instance

func add_gold(value:int) -> void:
	gold += value
	gold_updated.emit(gold)
	
func add_points(value:int) -> void:
	points += value
	points_updated.emit(points)
