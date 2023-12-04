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
		
static var __game_resources_data:Dictionary
var game_resources_data:Dictionary:
	get:
		if not __game_resources_data:
			var res_json_as_text: String = FileAccess.get_file_as_string(json_paths_file)
			__game_resources_data = JSON.parse_string(res_json_as_text)
		return __game_resources_data

func get_token_data_by_id(token_id: String) -> TokenData:
	# Retrieve the TokenData using the provided token_id
	if not __tokens_data.has(token_id):
		__load_tokens_data([token_id])
	
	assert(tokens_data[token_id], "Cannot load that token id ("+token_id+")")
	return tokens_data[token_id]

func __load_tokens_data(tokens_ids: Array) -> void:
	
	var tokens_dictionary : Dictionary = game_config_data[Constants.CONFIG_TOKENS]
	assert(tokens_dictionary, "there are no tokens in this config file")
	
	for token_id in tokens_ids:
		if token_id == '': # I use this for testing.. i guess? TODO: check
			continue
		assert(game_resources_data.has(token_id), "this id: "+token_id+" is not delcared in the tokens!!")
		assert(tokens_dictionary.has(token_id), "the id is not part of the tokens config file")
		print(">> loading data for: "+token_id)
		tokens_data[token_id] = load(game_resources_data[token_id])
		
		fulfill_token_data(tokens_data[token_id])


func fulfill_token_data(token_data:TokenData) -> void:
	
	#print("- before update:")
	#print(tokens_data[token_id])
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
		token_data.__prizes = get_chest_prizes_config_data(token_id)
	
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
	var config_chest_prizes = config_chests[chest_id]
	assert(config_chest_prizes, "cannot get prizes for id "+chest_id)
	return config_chest_prizes

func get_token_config_data(token_id:String) -> Dictionary:
	var config_tokens : Dictionary = game_config_data[Constants.CONFIG_TOKENS]
	var config_token_data = config_tokens[token_id]
	assert(config_token_data, "cannot get config token data  "+token_id)
	return config_token_data
