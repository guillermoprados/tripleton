extends Resource

class_name Difficulty

@export var name : String

@export_category("Level Config")
@export var save_token_slots: int
@export var max_level_token: int
@export var total_points: int

@export_category("Diff Tokens")
@export var common: Array[TokenData] = []
@export var uncommon: Array[TokenData] = []
@export var rare: Array[TokenData] = [] 
@export var scarce: Array[TokenData] = [] 
@export var unique: Array[TokenData] = [] 

var __validated : bool

func __validate()  -> void:
	assert(name, "name of set should be set")
	assert(common.size() > 0, name + ": common array should not be empty")
	assert(uncommon.size() > 0, name + ": uncommon array should not be empty")
	assert(rare.size() > 0, name + ": rare array should not be empty")
	assert(scarce.size() > 0, name + ": scarce array should not be empty")
	assert(unique.size() > 0, name + ": unique array should not be empty")
	__validated = true
	
func get_random_token_data() -> TokenData:
	
	if not __validated:
		__validate()	
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
