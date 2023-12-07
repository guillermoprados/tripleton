extends Node

class_name GameConfigData

var json_paths_file: String = "res://generated/res_tokens_data.json"
var json_config_file: String = "res://generated/game_config.json"

static var __tokens_data: Dictionary = {}
var tokens_data:Dictionary:
	get:
		return __tokens_data
		
static var __game_config_data:Dictionary
var game_config_data:Dictionary:
	get:
		if not __game_config_data:
			var game_config_data_text: String = FileAccess.get_file_as_string(json_config_file)
			__game_config_data = JSON.parse_string(game_config_data_text)
		return __game_config_data
		
static var __token_resources_path:Dictionary
var token_resources_path:Dictionary:
	get:
		if not __token_resources_path:
			var res_json_as_text: String = FileAccess.get_file_as_string(json_paths_file)
			__token_resources_path = JSON.parse_string(res_json_as_text)
		return __token_resources_path

func get_token_data_by_id(token_id: String) -> TokenData:
	# Retrieve the TokenData using the provided token_id
	if not __tokens_data.has(token_id):
		__load_tokens_data([token_id])
	
	assert(tokens_data[token_id], "Cannot load that token id ("+token_id+")")
	return tokens_data[token_id]

func __load_tokens_data(tokens_ids: Array) -> void:
	
	for token_id:String in tokens_ids:
		if token_id == '': # I use this for testing.. i guess? TODO: check
			continue
		assert(token_resources_path.has(token_id), "this id: "+token_id+" is not delcared in the tokens!!")
		print(">> loading data for: "+token_id)
		tokens_data[token_id] = load(token_resources_path[token_id])
		
		if game_config_data[Constants.CONFIG_TOKENS].has(token_id):
			fulfill_token_data(tokens_data[token_id])


func fulfill_token_data(token_data:TokenData) -> void:
	
	var token_id:String = token_data.id
	
	var config_token_data : Dictionary = get_token_config_data(token_id)
	
	if token_data is TokenCombinableData:
		if config_token_data.has("next_token_id"):
			token_data.__next_token_id = config_token_data["next_token_id"]
	
	if token_data is TokenPrizeData:
		if config_token_data.has("reward_type"):
			token_data.__reward_type = Utils.reward_type_from_string(config_token_data["reward_type"])
		if config_token_data.has("reward_value"):
			token_data.__reward_value = config_token_data["reward_value"]
		if config_token_data.has("collectable"):
			token_data.__collectable = bool(config_token_data["collectable"])
	
	if token_data is TokenChestData:
		var token_probs_by_set:Dictionary = get_chest_prizes_config_data(token_id)
		var token_set := TokenSet.new()
		for t_id:String in token_probs_by_set.keys():
			token_set.add_token_id(t_id, token_probs_by_set[t_id])
		token_data.__prizes = token_set
	
	#if token_data is TokenPrizeData:
	#	if reward_data['reward_type'] == "gold":
	#		token_data.reward_type = Constants.RewardType.GOLD
	#	else:
	#		token_data.reward_type = Constants.RewardType.POINTS
	#	token_data.reward_value = reward_data['reward_value']
	
	print("~~~-- ")
	print("- after update:")
	print(token_data)
	print("----------------")
	

func get_chest_prizes_config_data(chest_id:String) -> Dictionary:
	var config_chests : Dictionary = game_config_data[Constants.CONFIG_CHEST_PRIZES]
	var config_chest_prizes:Dictionary = config_chests[chest_id]
	assert(config_chest_prizes, "cannot get prizes for id "+chest_id)
	return config_chest_prizes

func get_token_config_data(token_id:String) -> Dictionary:
	var config_tokens : Dictionary = game_config_data[Constants.CONFIG_TOKENS]
	var config_token_data : Dictionary = config_tokens[token_id]
	assert(config_token_data, "cannot get config token data  "+token_id)
	return config_token_data

func get_difficulties_config_data(difficulty_id:Constants.DifficultyLevel) -> Dictionary:
	var diff_as_string := Difficulty.as_string(difficulty_id)
	var config_difficulties : Dictionary = game_config_data["difficulties"]
	var config_difficulty_data : Dictionary = config_difficulties[diff_as_string]
	assert(config_difficulty_data, "cannot get difficulty info for id " + diff_as_string)
	return config_difficulty_data
	
func get_spawn_probabilities_set_data(set_id:String) -> Dictionary:
	var spawn_probs : Dictionary = game_config_data["spawn_probabilities"]
	var spawn_probs_for_set: Dictionary = spawn_probs[set_id]
	assert(spawn_probs_for_set, "cannot get set info for id " + set_id)
	return spawn_probs_for_set
	
