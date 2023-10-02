extends Resource

class_name TokensConfig

@export var tokens : Array[TokenData] = []
@export var combinations : Array[TokenCombination] = []

# Verification method
func verify_configuration():
	# Check if all tokens have a unique ID
	var token_ids: Array = []
	for token in tokens:
		assert(not token.id in token_ids, "Duplicate token ID found: " + token.id)
		token_ids.append(token.id)
	
	# Check if combination have at least one token and prize set
	for combination in combinations:
		assert(combination.ordered_tokens.size() > 0, "Combination " + combination.name + " has no tokens in ordered_tokens.")
		assert(combination.prize != null, "Combination " + combination.name + " does not have a prize set.")
