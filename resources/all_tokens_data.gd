extends Node

class_name AllTokensData

@export var json_path: String = "res://data/res_tokens_data.json"
var tokens_data: Dictionary = {}

func get_token_data_by_id(token_id: String) -> TokenData:
	# Retrieve the TokenData using the provided token_id
	if not tokens_data.has(token_id):
		load_token_data(token_id)
	
	assert(tokens_data[token_id], "Cannot load that token id")
	return tokens_data[token_id]

func load_token_data(token_id: String) -> void:
	# Load the JSON file
	var json_as_text: String = FileAccess.get_file_as_string(json_path)
	var tokens_as_dict: Dictionary = JSON.parse_string(json_as_text)
	assert(tokens_as_dict.has(token_id), "this id is not delcared in the tokens!!")
	tokens_data[token_id] = load(tokens_as_dict[token_id])
