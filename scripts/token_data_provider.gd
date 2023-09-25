extends Node

class_name TokenDataProvider

@export var tokens_config: TokensConfig

var tokens: Array = []
var token_data_by_token_id: Dictionary;
var token_category_by_token_id: Dictionary;

func _ready():
	token_data_by_token_id = {}
	for cat in tokens_config.categories:
		for token_data in cat.ordered_tokens:
			token_data_by_token_id[token_data.id] = token_data

	token_category_by_token_id = {}
	for cat in tokens_config.categories:
		for token_data in cat.ordered_tokens:
			token_category_by_token_id[token_data.id] = cat.name
						
						
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
