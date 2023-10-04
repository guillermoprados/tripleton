extends Control

class_name AwardPoints

var points_label: Label

# Duration for which the points should be displayed
@export var display_duration: float = 0.5

# Scale factors for the animation
@export var initial_scale: Vector2 = Vector2(1.0, 1.0)
@export var expansion_scale: Vector2 = Vector2(1.2, 1.2)
@export var shrink_scale: Vector2 = Vector2(0.5, 0.5)

# Vertical movement delta
@export var vertical_delta: float = 20.0

enum State { 
	EXPAND, 
	SHRINK, 
	FINISHED 
}

var current_state: State = State.EXPAND
var elapsed_time: float = 0.0
var expansion_duration: float
var initial_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	points_label = $Points
	points_label.text = "0"
	expansion_duration = display_duration / 3.0
	initial_position = position

func show_points(value: int):
	var points_text: String
	
	if value > 0:
		points_text = "+ " + str(value)
	else:
		points_text = "- " + str(value * -1)
	
	points_label.text = points_text
	$DisplayTimer.start(display_duration)
	set_process(true)

func _process(delta):
	elapsed_time += delta
	
	# Move node vertically during the whole process
	var vertical_t = elapsed_time / display_duration
	position.y = initial_position.y - vertical_delta * vertical_t
	
	match current_state:
		State.EXPAND:
			var expand_t = elapsed_time / expansion_duration
			self.scale = initial_scale + (expansion_scale - initial_scale) * expand_t
			if elapsed_time >= expansion_duration:
				current_state = State.SHRINK
				elapsed_time = 0.0
		State.SHRINK:
			var shrink_t = elapsed_time / (display_duration - expansion_duration)
			self.scale = expansion_scale + (shrink_scale - expansion_scale) * shrink_t
			if elapsed_time >= (display_duration - expansion_duration):
				current_state = State.FINISHED
				set_process(false)
		State.FINISHED:
			pass

func _on_display_timer_timeout():
	queue_free()
