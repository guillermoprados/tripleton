extends RefCounted

class_name TokenDataProvider

var _resource_item_pool: Array = []

var token_data_by_token_id: Dictionary = {}
var token_combination_by_token_id: Dictionary = {}
var token_chest_by_token_id: Dictionary = {}
var prize_tokens_ids: Array[String] = []

func _init(game_config:GameConfig):
	for chest_data in game_config.chests:
		token_chest_by_token_id[chest_data.chest.id] = chest_data		
		# add tokens from chest prizes
		for token_data in chest_data.prizes:
			token_data_by_token_id[token_data.id] = token_data		
			prize_tokens_ids.append(token_data.id)
			
	for comb in game_config.combinations:
		for token_data in comb.ordered_tokens:
			token_combination_by_token_id[token_data.id] = comb
			# add tokens from combinations
			token_data_by_token_id[token_data.id] = token_data		
		token_data_by_token_id[comb.chest_prize.chest.id] = comb.chest_prize.chest
	
	for token_data in token_data_by_token_id.values():
		token_data.validate()
	

func token_is_combinable(token_id: String) -> bool:
	return token_combination_by_token_id.has(token_id)

func get_next_level_data(token_id:String) -> TokenData:
	var next_level_token_id = get_token_id_for_next_level(token_id)
	if next_level_token_id != Constants.INVALID_TOKEN_ID:
		return token_data_by_token_id[next_level_token_id]
	return null
	
func get_previous_level_data(token_id:String) -> TokenData:
	var previous_level_token_id = get_token_id_for_previous_level(token_id)
	if previous_level_token_id != Constants.INVALID_TOKEN_ID:
		return token_data_by_token_id[previous_level_token_id]
	return null

func get_prize_for_token_combination(token_id) -> TokenData:
	return token_combination_by_token_id[token_id].chest_prize.chest

func token_has_next_level(token_id: String) -> bool:
	return get_token_id_for_next_level(token_id) != Constants.INVALID_TOKEN_ID

func token_has_previous_level(token_id: String) -> bool:
	return get_token_id_for_previous_level(token_id) != Constants.INVALID_TOKEN_ID

func get_level_for_token_id(token_id: String) -> int:
	var comb = token_combination_by_token_id[token_id]
	for level in range(comb.ordered_tokens.size()):
		if comb.ordered_tokens[level].id == token_id:
			return level
	return 0

func get_number_of_levels_for_token_id(token_id: String) -> int:
	return token_combination_by_token_id[token_id].ordered_tokens.size()

func get_token_id_for_next_level(token_id: String) -> String:
	var current_level = get_level_for_token_id(token_id)
	var total_levels = get_number_of_levels_for_token_id(token_id)
	var next_token_id = Constants.INVALID_TOKEN_ID
	
	if current_level < total_levels - 1:
		next_token_id = token_combination_by_token_id[token_id].ordered_tokens[current_level + 1].id
	
	return next_token_id

func get_token_id_for_previous_level(token_id: String) -> String:
	var current_level = get_level_for_token_id(token_id)
	var prev_token_id = Constants.INVALID_TOKEN_ID
	if current_level > 0:
		var combination = token_combination_by_token_id[token_id]
		prev_token_id = combination.ordered_tokens[current_level - 1].id
	return prev_token_id

func token_is_chest(token_id: String) -> bool:
	return token_chest_by_token_id.has(token_id)
	
func get_chest(token_id: String) -> TokenChest: 
	return token_chest_by_token_id[token_id]

func token_is_prize(token_id: String) -> bool:
	return prize_tokens_ids.has(token_id)
