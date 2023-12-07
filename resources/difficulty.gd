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

var __tokens_set: TokenSet

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

func get_random_token_data_id() -> String:
	assert(__tokens_set, "There is no token set for this difficulty")
	return __tokens_set.get_random_token_data_id()	
		
