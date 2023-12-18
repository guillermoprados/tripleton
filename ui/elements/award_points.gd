extends Node2D

class_name AwardPoints

var points_label: Label

# Duration for which the points should be displayed
@export var display_duration: float = 1
@export var scale_speed : float = 5
@export var move_up_speed : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points_label = $Points
	points_label.text = "0"
	show_points(50)

func _process(delta:float) -> void:
	if scale.y < 1:
		scale += Vector2.ONE * delta * scale_speed
	position.y -= delta * move_up_speed
	
func show_points(value: int) -> void:
	scale = Vector2.ZERO
	points_label.text = "+"+str(value)
	$DisplayTimer.start(display_duration)
	
func _on_display_timer_timeout() -> void:
	queue_free()
