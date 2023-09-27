extends Resource

class_name TokensConfig

@export var tokens : Array[TokenData] = []
@export var categories : Array[TokenCategory] = []

# Verification method
func verify_configuration():
	# Check if all tokens have a unique ID
	var token_ids: Array = []
	for token in tokens:
		assert(not token.id in token_ids, "Duplicate token ID found: " + str(token.id)+" on "+token.name)
		token_ids.append(token.id)
	
	# Check if categories have at least one token and prize set
	for category in categories:
		assert(category.ordered_tokens.size() > 0, "Category " + category.name + " has no tokens in ordered_tokens.")
		assert(category.prize != null, "Category " + category.name + " does not have a prize set.")
