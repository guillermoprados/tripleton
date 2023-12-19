extends Node2D

class_name AwardPoints

var points_label: RichTextLabel
var particles: CPUParticles2D

# Duration for which the points should be displayed
@export var display_duration: float = 1
@export var move_up_speed : float = 5

var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	points_label = $Points
	scale = Vector2.ZERO
	
	particles = $Particles
	points_label.text = "0"
	particles.set_emitting(false)
	
	show_points(50)
	

func show_points(value: int) -> void:
	points_label.text = "[tornado radius=5.0 freq=10.0]+"+str(value)
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, display_duration / 4)
	tween.tween_property(self, "position:y", position.y - 50, display_duration)
	tween.tween_property(points_label, "modulate:a", 0, display_duration*1.5)
	# TODO: use a real reference for position?
	tween.tween_property(self, "position", Vector2.ZERO, display_duration).set_delay(display_duration)
	tween.tween_callback(queue_free).set_delay(display_duration*2)
	
	$DisplayTimer.start(display_duration)
	
func _on_display_timer_timeout() -> void:
	particles.set_emitting(true)
	
func _on_points_finished() -> void:
	tween.kill()
	tween = create_tween()
	


