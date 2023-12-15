extends Node2D

class_name AutoEscalableNode2D

var original_pos:Vector2
var original_scale:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_pos = position
	original_scale = scale
	
	get_viewport().size_changed.connect(__auto_scale)
	__auto_scale()
	
	
func __auto_scale() -> void:
	var scale_factor:Vector2 = get_tree().root.content_scale_size
	var screen_size:Vector2 = get_viewport().get_visible_rect().size
	position = screen_size * original_pos / scale_factor
	scale = screen_size * original_scale / scale_factor

	
