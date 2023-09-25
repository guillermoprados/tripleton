extends Node

class_name TokenDataProvider

@export var tokens_config: TokensConfig

var token_data_by_token_id: Dictionary
var token_category_by_token_id: Dictionary
var categories_by_name: Dictionary
var combinable_tokens_ids: Array = [] #stores all the tokens that are in fact combinable

func _ready():
	token_data_by_token_id = {}
	for cat in tokens_config.categories:
		categories_by_name[cat.name] = cat
		for token_data in cat.ordered_tokens:
			token_data_by_token_id[token_data.id] = token_data
			combinable_tokens_ids.append(token_data.id)
	
	token_category_by_token_id = {}
	for cat in tokens_config.categories:
		for token_data in cat.ordered_tokens:
			token_category_by_token_id[token_data.id] = cat.name
			
	categories_by_name = {}
	

func is_token_combinable(token_id: int) -> bool:
	return combinable_tokens_ids.has(token_id)
	
func get_token_data_by_category(category_name: String, level: int) -> TokenData:
	# Find the matching category
	for cat in tokens_config.categories:
		if cat.name == category_name:
			# Check if the level is valid for this category
			assert (level >= 0 && level < cat.ordered_tokens.size(), "Level index out of range for category: " + category_name)
			return cat.ordered_tokens[level]

	# No matching category found
	assert(false, "Category not found: " + category_name)
	return null

func get_level_for_token_id(token_id: int) -> int:
	var category_name = token_category_by_token_id[token_id]
	
	for cat in tokens_config.categories:
		if cat.name == category_name:
			for level in range(cat.ordered_tokens.size()):
				if cat.ordered_tokens[level].id == token_id:
					return level
	
	return 0

func get_number_of_levels_for_token_id(token_id: int) -> int:
	var category_name = token_category_by_token_id[token_id]
	
	for cat in tokens_config.categories:
		if cat.name == category_name:
			return cat.ordered_tokens.size()
	
	return 0

func get_token_id_for_next_level(token_id: int) -> int:
	var current_level = get_level_for_token_id(token_id)
	var total_levels = get_number_of_levels_for_token_id(token_id)
	
	if current_level < total_levels - 1:
		var category = token_category_by_token_id[token_id]
		
		for cat in tokens_config.categories:
			if cat.name == category:
				return cat.ordered_tokens[current_level + 1].id
	
	return Constants.INVALID_TOKEN_ID

func token_has_next_level(token_id: int) -> bool:
	return get_token_id_for_next_level(token_id) != Constants.INVALID_TOKEN_ID
