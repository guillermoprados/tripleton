extends Node

class_name DinastyManager

signal dinasty_changed()

var __dinasties: Array[Dinasty]

var __dinasty_index : int = -1

var current_dinasty:Dinasty:
	get:
		return __dinasties[__dinasty_index]

func set_dinasties(dinasties:Array[Dinasty]) -> void:
	__dinasties = dinasties
	next_dinasty()

# keeps the earned points of the current dinasty
var __dinasty_points : int
var dinasty_points: int:
	get:
		return __dinasty_points

var is_last_dinasty: bool:
	get:
		return __dinasty_index == __dinasties.size() - 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var backgound:CompressedTexture2D:
	get:
		return current_dinasty.map_texture
		
func next_dinasty() -> void:
	__dinasty_index += 1
	print("change dinasty: "+str(current_dinasty.name)+" points: "+str(current_dinasty.total_points))
	dinasty_changed.emit()


func _on_game_manager_points_added(added_points:int, total_points:int) -> void:
	
	__dinasty_points += added_points
	
	if dinasty_points >= current_dinasty.total_points and not is_last_dinasty:
		var overflow : int = dinasty_points - current_dinasty.total_points
		next_dinasty()
		__dinasty_points = overflow
