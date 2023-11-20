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
var earned_points : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var backgound:CompressedTexture2D:
	get:
		return current_dinasty.map_texture
		
func add_points(points:int) -> void:
	
	earned_points += points
	
	if earned_points >= current_dinasty.total_points:
		var overflow : int = earned_points - current_dinasty.total_points
		next_dinasty()
		earned_points = overflow
		
func next_dinasty() -> void:
	__dinasty_index += 1
	print("change dinasty: "+str(current_dinasty.name)+" points: "+str(current_dinasty.total_points))
	dinasty_changed.emit()
