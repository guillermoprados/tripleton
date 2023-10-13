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
	tokens_pool = RandomResourcePool.new()
	level_config.validate()
	pass
	
func instantiate_new_token(token_data:TokenData, position:Vector2, parent:Node) -> Token:
	var token:Token = get_token_instance(token_data)
	if parent:
		parent.add_child(token)
	token.position = position
	return token


func set_next_tokens_set(config:LevelConfig) -> void:
	print(">> Finished current token set with "+str(points)+" points")
	var _tokens_set: TokensSet
	if level_config.tokens_sets.size() > 1:
		_tokens_set = level_config.tokens_sets.pop_front()
	else:
		_tokens_set = level_config.tokens_sets[0]
		print(">> We ran out of token sets.. gonna need to repeat the last one "+_tokens_set.name)
		
	print(">> Setting Token Set "+_tokens_set.name)
	
	tokens_pool.add_items(_tokens_set.items, true)	
	
func get_random_token_data() -> TokenData:
	
	# If list is empty, emit the difficulty_depleted signal
	# im gonna fix this later to make this more lindo
	if tokens_pool.is_empty():
		set_next_tokens_set(level_config)
		
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
