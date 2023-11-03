extends Node

class_name InRangeTweener

@export var sprite_holder:Node2D
@export var shadow:Node2D

var _in_range_of_cell: Vector2

var in_range_of_cell: Vector2:
	get:
		return _in_range_of_cell
	set (value):
		if _in_range_of_cell == value:
			return
			
		_in_range_of_cell = value
		if _in_range_of_cell != Constants.INVALID_CELL:
			sprite_holder.position.y = Constants.TOKEN_IN_RANGE_Y_POS
			shadow.scale = Vector2(Constants.TOKEN_SHADOW_FLOATING_MULTIPLIER, Constants.TOKEN_SHADOW_FLOATING_MULTIPLIER)
		else:
			sprite_holder.position.y = Constants.TOKEN_PLACED_Y_POS
			shadow.scale = Vector2.ONE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
