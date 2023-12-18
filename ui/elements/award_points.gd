extends Node2D

class_name AwardPoints

var points_label: RichTextLabel

# Duration for which the points should be displayed
@export var display_duration: float = 1
@export var move_up_speed : float = 5

var tween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points_label = $Points
	points_label.text = "0"
	scale = Vector2.ZERO

func show_points(value: int) -> void:
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, display_duration / 4)
	tween.tween_property(self, "position:y", position.y - 50, display_duration)
	tween.tween_property(self, "position:y", position.y - 50, display_duration)
	tween.tween_property(self, "modulate:a", 0, display_duration*1.5)
	points_label.text = "[tornado radius=5.0 freq=10.0]+"+str(value)
	$DisplayTimer.start(display_duration)
	
func _on_display_timer_timeout() -> void:
	queue_free()
