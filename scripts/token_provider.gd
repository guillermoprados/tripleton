extends Resource

class_name TokenProvider

@export var token_scene: PackedScene
@export var tokens_config: TokensConfig 

var probabilities: Array = [60, 20, 10, 5, 5]  # and so on, you can extend this as needed

func get_token_instance() -> Token:
	# Filter out non-spawnable categories
	var spawnable_categories = []
	for category in tokens_config.categories:
		if category.spawneable:
			spawnable_categories.append(category)

	# Check if we have more spawnable categories than probabilities provided
	if spawnable_categories.size() > probabilities.size():
		printerr("Not enough probabilities provided for the number of spawnable categories!")
		return null
	
	# Normalize the probabilities so they sum up to 1
	var total_prob = 0
	for prob in probabilities:
		total_prob += prob
	var normalized_probs = []
	for prob in probabilities:
		normalized_probs.append(prob / total_prob)
	
	# Select a category based on the normalized probabilities
	var selected_category = _pick_weighted(spawnable_categories, normalized_probs)
	
	# Select a random token from the chosen category
	var token_index = randi() % selected_category.ordered_tokens.size()
	var chosen_token = selected_category.ordered_tokens[token_index]
	chosen_token.id = token_index
	
	# Instantiate and set data
	var token_instance = token_scene.instantiate()
	token_instance.set_data(chosen_token)
	
	return token_instance

# Function to pick an item based on weights
func _pick_weighted(items: Array, weights: Array) -> Variant:
	var total_weight = 1.0
	var choice = randf()

	for i in range(items.size()):
		if choice < weights[i]:
			return items[i]
		choice -= weights[i]

	return items[items.size() - 1]  # Just in case of some floating-point inaccuracies
