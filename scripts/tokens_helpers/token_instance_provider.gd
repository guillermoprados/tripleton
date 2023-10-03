extends Node

class_name TokenInstanceProvider

@export var token_scene: PackedScene

signal difficulty_depleted()

# list of token data
var tokens_pool: RandomResourcePool

func set_difficulty_tokens(difficulty: GameDifficulty) -> void:
	tokens_pool = RandomResourcePool.new(difficulty.items)

func get_random_token_instance() -> Token:
	
	# Assert if list is empty
	assert(!tokens_pool.is_empty(), "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data = tokens_pool.pop_item()
	
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	# If list is empty, emit the difficulty_depleted signal
	if tokens_pool.is_empty():
		difficulty_depleted.emit()
	
	return token_instance

func get_token_instance(token_data: TokenData) -> Token:
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	return token_instance
