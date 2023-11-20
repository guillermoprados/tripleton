extends Node

class_name DinastyManager

@export var dinasties : Array[Dinasty]

signal dinasty_changed(name:String, max_points:int, overflow:int)

var dinasty_index : int = -1
var current_dinasty:Dinasty

func _enter_tree() -> void:
	assert(dinasties, "cannot load dinasties")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var max_level_allowed:int:
	get:
		return current_dinasty.difficulty.max_level_token

var backgound:CompressedTexture2D:
	get:
		return current_dinasty.map_texture

func get_random_token_data() -> TokenData:
	var token_data := current_dinasty.difficulty.tokens.get_random_token_data() ## mmmmmm
	return token_data
		
func add_points(points:int) -> void:
	current_dinasty.earned_points += points
	if current_dinasty.earned_points >= current_dinasty.total_points:
		var overflow : int = current_dinasty.earned_points - current_dinasty.total_points
		next_dinasty(overflow)

func next_dinasty(overflow:int) -> void:
	dinasty_index += 1
	current_dinasty = dinasties[dinasty_index]
	print("change dinasty: "+str(current_dinasty.name)+" points: "+str(current_dinasty.total_points))
	current_dinasty.earned_points = overflow
	dinasty_changed.emit(current_dinasty.name, current_dinasty.total_points)
