extends Node

class_name AllTokensData

@export var json_paths: String = "res://generated/res_tokens_data.json"
@export var json_rewards: String = "res://generated/tokens_values.json"

static var tokens_data: Dictionary = {}

func get_token_data_by_id(token_id: String) -> TokenData:
	# Retrieve the TokenData using the provided token_id
	if not tokens_data.has(token_id):
		__load_tokens_data([token_id])
	
	assert(tokens_data[token_id], "Cannot load that token id")
	return tokens_data[token_id]

func __load_tokens_data(tokens_ids: Array) -> void:
	# Load the JSON file
	var res_json_as_text: String = FileAccess.get_file_as_string(json_paths)
	var res_tokens_as_dict: Dictionary = JSON.parse_string(res_json_as_text)
	
	var reward_json_as_text: String = FileAccess.get_file_as_string(json_rewards)
	var reward_tokens_as_dict: Dictionary = JSON.parse_string(reward_json_as_text)
	
	for token_id in tokens_ids:
		if token_id == '':
			continue
		assert(res_tokens_as_dict.has(token_id), "this id is not delcared in the tokens!!")
		print("loading data for: "+token_id)
		tokens_data[token_id] = load(res_tokens_as_dict[token_id])
		if reward_tokens_as_dict.has(token_id):
			update_token_data(tokens_data[token_id], reward_tokens_as_dict[token_id])
		else:
			print("nothing")

func update_token_data(token_data:TokenData, reward_data:Dictionary) -> void:
	print("before update:")
	str(tokens_data)
	
	if token_data is TokenPrizeData:
		if reward_data['reward_type'] == "gold":
			token_data.reward_type = Constants.RewardType.GOLD
		else:
			token_data.reward_type = Constants.RewardType.POINTS
		token_data.reward_value = reward_data['reward_value']
		
	print("after update:")
	str(tokens_data)
		
