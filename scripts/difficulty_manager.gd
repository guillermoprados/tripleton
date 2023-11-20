extends Node

class_name DifficultyManager


var __difficulties : Array[Difficulty]

signal difficulty_changed(number_of_save_slots:int, mas_level_tokens:int)

var __diff_index : int = -1
var current_difficulty:Difficulty:
	get:
		return __difficulties[__diff_index]
		
# keeps record of the points of this difficulty
var earned_points:int

func set_difficulties(diffs:Array[Difficulty]) -> void:
	__difficulties = diffs
	next_difficulty()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_token_data() -> TokenData:
	var token_data := current_difficulty.get_random_token_data()
	return token_data
		
func add_points(points:int) -> void:
	earned_points += points
	if earned_points >= current_difficulty.total_points:
		var overflow : int = earned_points - current_difficulty.total_points
		next_difficulty()
		earned_points = overflow

func next_difficulty() -> void:
	__diff_index += 1
	print("change diff: "+str(current_difficulty.name)+" points: "+str(current_difficulty.total_points))
	difficulty_changed.emit(current_difficulty.save_token_slots, current_difficulty.max_level_token)
