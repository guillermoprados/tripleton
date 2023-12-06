extends RefCounted

class_name Difficulty

var __level : Constants.DifficultyLevel
var level : Constants.DifficultyLevel:
	get:
		return __level
		
var __save_token_slots: int
var save_token_slots: int:
	get:
		return __save_token_slots
		
var __max_level_token: int
var max_level_token: int:
	get:
		return __max_level_token
		
var __max_level_chest_id: String
var max_level_chest_id: String:
	get:
		return __max_level_chest_id

var __total_points: int
var total_points: int:
	get:
		return __total_points

var __common_token_ids: Array[String] = []
var __frequent_token_ids: Array[String] = []
var __rare_token_ids: Array[String] = [] 
var __scarce_token_ids: Array[String] = [] 
var __unique_token_ids: Array[String] = [] 

var __validated : bool

static func as_string(level:Constants.DifficultyLevel) -> String:
	match(level):
		Constants.DifficultyLevel.EASY:
			return "easy"
		Constants.DifficultyLevel.MEDIUM:
			return "medium"
		Constants.DifficultyLevel.HARD:
			return "hard"
		Constants.DifficultyLevel.SUPREME:
			return "supreme"
		Constants.DifficultyLevel.LEGENDARY:
			return "legendary"
	assert(false, "cannot cast level : "+as_string(level))
	return "wtf"

static func from_string(level:String) -> Constants.DifficultyLevel:
	match(level):
		"easy":
			return Constants.DifficultyLevel.EASY
		"medium":
			return Constants.DifficultyLevel.MEDIUM
		"hard":
			return Constants.DifficultyLevel.HARD
		"supreme":
			return Constants.DifficultyLevel.SUPREME
		"legendary":
			return Constants.DifficultyLevel.LEGENDARY
	
	assert(false, "cannot cast level : "+level)
	return Constants.DifficultyLevel.EASY

var name:String:
	get:
		return as_string(level)

func __validate()  -> void:
	assert(__common_token_ids.size() > 0, name + ": common array should not be empty")
	assert(__frequent_token_ids.size() > 0, name + ": uncommon array should not be empty")
	assert(__rare_token_ids.size() > 0, name + ": rare array should not be empty")
	assert(__scarce_token_ids.size() > 0, name + ": scarce array should not be empty")
	assert(__unique_token_ids.size() > 0, name + ": unique array should not be empty")
	__validated = true
	
func get_random_token_data_id() -> String:
	
	if not __validated:
		__validate()	
		# if you want to debug the values
		# run_simulation(10000, self)
	
	var rand_val := randf()
	
	if rand_val < Constants.TOKEN_PROB_COMMON:
		return get_random_from_array(__common_token_ids)
	elif rand_val < Constants.TOKEN_PROB_UNCOMMON:
		return get_random_from_array(__frequent_token_ids)
	elif rand_val < Constants.TOKEN_PROB_RARE:
		return get_random_from_array(__rare_token_ids)
	elif rand_val < Constants.TOKEN_PROB_SCARCE:
		return get_random_from_array(__scarce_token_ids)
	else:
		return get_random_from_array(__unique_token_ids)
		
func get_random_from_array(arr: Array) -> String:
	return arr[randi() % arr.size()]
