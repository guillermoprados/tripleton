extends Node

class_name DifficultyManager

signal difficulty_changed()

var __diff_index : int = -1
var __difficulties : Array[Difficulty]


var current_difficulty:Difficulty:
	get:
		return __difficulties[__diff_index]
		
# keeps record of the points of this difficulty
var __current_points := 0
var diff_points:int:
	get:
		return __current_points

var is_last_difficulty: bool:
	get:
		return __diff_index == __difficulties.size() - 1

var __level_limit_enabled:bool = true
func disable_level_limit() -> void:
		__level_limit_enabled = false
	
var token_level_limit:int:
	get:
		if __level_limit_enabled:
			return current_difficulty.max_level_token
		else:
			return 5000 
			
func set_difficulties(diffs:Array[Difficulty]) -> void:
	__difficulties = diffs
	next_difficulty()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func next_difficulty() -> void:
	__diff_index += 1
	print("change diff: "+str(current_difficulty.name)+" points: "+str(current_difficulty.total_points))
	difficulty_changed.emit()

func _on_game_manager_points_added(added_points:int, total_points:int) -> void:
	__current_points += added_points
	if diff_points >= current_difficulty.total_points and not is_last_difficulty:
		var overflow : int = diff_points - current_difficulty.total_points
		next_difficulty()
		__current_points = overflow
