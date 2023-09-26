extends Node

class_name TokenDataProvider

@export var tokens_config: TokensConfig

var token_data_by_token_id: Dictionary
var token_category_by_token_id: Dictionary
var categories_by_name: Dictionary
var combinable_tokens_ids: Array = [] #stores all the tokens that are in fact combinable

func _ready():
	tokens_config.verify_configuration()
	
	token_data_by_token_id = {}
	for cat in tokens_config.categories:
		categories_by_name[cat.name] = cat
		for token_data in cat.ordered_tokens:
			token_data_by_token_id[token_data.id] = token_data
			combinable_tokens_ids.append(token_data.id)
	
	token_category_by_token_id = {}
	for cat in tokens_config.categories:
		for token_data in cat.ordered_tokens:
			token_category_by_token_id[token_data.id] = cat
			
	categories_by_name = {}

func is_token_combinable(token_id: int) -> bool:
	return combinable_tokens_ids.has(token_id)
	
func get_next_level_data(token_id:int) -> TokenData:
	var next_level_token_id = get_token_id_for_next_level(token_id)
	if next_level_token_id != Constants.INVALID_TOKEN_ID:
		return token_data_by_token_id[next_level_token_id]
	return null

func get_prize_for_token_category(token_id) -> TokenData:
	return token_category_by_token_id[token_id].prize

func token_has_next_level(token_id: int) -> bool:
	return get_token_id_for_next_level(token_id) != Constants.INVALID_TOKEN_ID

func get_level_for_token_id(token_id: int) -> int:
	var cat = token_category_by_token_id[token_id]
	for level in range(cat.ordered_tokens.size()):
		if cat.ordered_tokens[level].id == token_id:
			return level
	return 0

func get_number_of_levels_for_token_id(token_id: int) -> int:
	return token_category_by_token_id[token_id].ordered_tokens.size()

func get_token_id_for_next_level(token_id: int) -> int:
	var current_level = get_level_for_token_id(token_id)
	var total_levels = get_number_of_levels_for_token_id(token_id)
	var next_token_id = Constants.INVALID_TOKEN_ID
	
	if current_level < total_levels - 1:
		next_token_id = token_category_by_token_id[token_id].ordered_tokens[current_level + 1].id
	
	return next_token_id

