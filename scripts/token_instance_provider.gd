extends Node

class_name TokenInstanceProvider

@export var token_scene: PackedScene

signal difficulty_depleted()

# list of token data
var items_data: Array = []

func set_difficulty_tokens(difficulty: GameDifficulty) -> void:
	# Create a list of tokens data
	var temp_list: Array = []
	for item in difficulty.items:
		for _i in range(item.number_of_items):
			temp_list.append(item.token)
	
	# Randomize the list
	temp_list.shuffle()
	
	# Assign the randomized list to items_data
	items_data = temp_list

func get_random_token_instance() -> Token:
	
	# Assert if list is empty
	assert(items_data.size() > 0, "TokenInstanceProvider: No more tokens left.")
	
	# Pop the first item in the items_data and get the data from it
	var token_data = items_data.pop_front()
	
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	# If list is empty, emit the difficulty_depleted signal
	if items_data.size() == 0:
		difficulty_depleted.emit()
	
	return token_instance

func get_token_instance(token_data: TokenData) -> Token:
	# Instantiate and return the chosen token instance
	var token_instance: Token = token_scene.instantiate() as Token
	token_instance.set_data(token_data)
	
	return token_instance
