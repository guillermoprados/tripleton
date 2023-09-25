extends Node2D

class_name TokenInstanceProvider

@export var token_scene: PackedScene
@export var level_config: LevelConfig  # Reference to your level config resource

var tokens: Array = []
var probabilities: Array = []

func _ready():
	# Get the current difficulty (for now, it's the first one)
	var current_difficulty = level_config.difficulties[0]

	# If there's no difficulty set, or no probabilities, return
	if current_difficulty == null or current_difficulty.probabilities.size() == 0:
		assert("No difficulties or probabilities set!")
	
	var total_prob = 0.0
	for prob_entry in current_difficulty.probabilities:
		tokens.append(prob_entry.token)
		probabilities.append(prob_entry.probability)
		total_prob += prob_entry.probability
	
	# Normalize the probabilities
	for i in range(probabilities.size()):
		probabilities[i] /= total_prob
	print("probs:",probabilities)

func get_token_instance() -> Token:
	# Select a token based on the probabilities
	var chosen_token = __pick_weighted(tokens, probabilities)
	
	# Instantiate and return the chosen token instance
	var token_instance = token_scene.instantiate()
	token_instance.set_data(chosen_token)
	
	return token_instance

# Function to pick an item based on weights
func __pick_weighted(items: Array, weights: Array) -> Variant:
	var choice = randf()

	for i in range(items.size()):
		if choice < weights[i]:
			return items[i]
		choice -= weights[i]

	return items[items.size() - 1]  # Just in case of some floating-point inaccuracies
