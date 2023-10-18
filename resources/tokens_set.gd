extends Resource

class_name TokensSet

@export var name:String

@export var common: Array[TokenData] = []
@export var uncommon: Array[TokenData] = []
@export var rare: Array[TokenData] = [] 
@export var scarce: Array[TokenData] = [] 
@export var unique: Array[TokenData] = [] 

var validated : bool

func validate()  -> void:
	assert(name, "name of set should be set")
	assert(common.size() > 0, name + ": common array should not be empty")
	assert(uncommon.size() > 0, name + ": uncommon array should not be empty")
	assert(rare.size() > 0, name + ": rare array should not be empty")
	assert(scarce.size() > 0, name + ": scarce array should not be empty")
	assert(unique.size() > 0, name + ": unique array should not be empty")
	validated = true
	
func get_random_token_data() -> TokenData:
	
	if not validated:
		validate()	
		# if you want to debug the values
		# run_simulation(10000, self)
	
	var rand_val = randf()
	
	if rand_val < Constants.TOKEN_PROB_COMMON:
		return get_random_from_array(common)
	elif rand_val < Constants.TOKEN_PROB_UNCOMMON:
		return get_random_from_array(uncommon)
	elif rand_val < Constants.TOKEN_PROB_RARE:
		return get_random_from_array(rare)
	elif rand_val < Constants.TOKEN_PROB_SCARCE:
		return get_random_from_array(scarce)
	else:
		return get_random_from_array(unique)
		
func get_random_from_array(arr: Array) -> TokenData:
	return arr[randi() % arr.size()]

static func run_simulation(num_draws:int, tokens_set: TokensSet) -> void:
	var category_counts = {
		"Common": 0,
		"Uncommon": 0,
		"Rare": 0,
		"Scarce": 0,
		"Unique": 0
	}
	
	var item_counts: Dictionary = {}  # Dictionary to keep counts of each item
	
	for i in range(num_draws):
		var token_data: TokenData = tokens_set.get_random_token_data()
		var category: String
		if tokens_set.common.has(token_data):
			category = "Common"
		elif tokens_set.uncommon.has(token_data):
			category = "Uncommon"
		elif tokens_set.rare.has(token_data):
			category = "Rare"
		elif tokens_set.scarce.has(token_data):
			category = "Scarce"
		else:
			category = "Unique"
		
		category_counts[category] += 1
		
		var item_name = token_data.id  # Assuming each TokenData has a `name` property
		if not item_counts.has(item_name):
			item_counts[item_name] = 0
		item_counts[item_name] += 1

	print("Simulation Results:")
	for category in category_counts:
		print("%s: %.2f%%" % [category, 100.0 * category_counts[category] / num_draws])
	
	print("\nItem Occurrences:")
	for item_name in item_counts:
		print("%s: %d times" % [item_name, item_counts[item_name]])
