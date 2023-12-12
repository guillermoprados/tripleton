extends Sprite2D

class_name MenuMountain

@export var normal_position_marker: Marker2D
@export var bottom_position_marker: Marker2D

var movement_tweener: Tween
var current_marker:Marker2D
var animating:bool = false

func _ready() -> void: 
	current_marker = normal_position_marker

func _process(delta:float) -> void:
	if not animating:
		position = current_marker.position
			 	
func animate_from_button() -> void:
	pass
	
