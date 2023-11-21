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


func set_difficulties(diffs:Array[Difficulty]) -> void:
	__difficulties = diffs
	next_difficulty()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_next_token_data() -> TokenData:
	var token_data := current_difficulty.get_random_token_data()
	return token_data
		

func next_difficulty() -> void:
	__diff_index += 1
	print("change diff: "+str(current_difficulty.name)+" points: "+str(current_difficulty.total_points))
	difficulty_changed.emit()


func _on_game_manager_points_added(added_points, total_points):
	__current_points += added_points
	if diff_points >= current_difficulty.total_points and (__diff_index < __difficulties.size() -1):
		var overflow : int = diff_points - current_difficulty.total_points
		next_difficulty()
		__current_points = overflow
