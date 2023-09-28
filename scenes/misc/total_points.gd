extends Node2D

class_name TotalPoints

var display_points: float = 0
@export var total_points: int = 0

@export var increase_time: float = 1.0  # Time to go from display_points to total_points
@export var scale_delta: float = 0.1  # Amount by which scale will change

# New color exports
@export var DecreaseColor: Color = Color(1, 0, 0)  # Default to red
@export var IncreaseColor: Color = Color(0, 1, 0)  # Default to green

var points: Label
var elapsed_time: float = 0.0
var original_font_color: Color

enum ScaleState {
	INCREASE,
	DECREASE
}
var current_scale_state = ScaleState.INCREASE

var increment_rate: float = 0.0  # This will be our constant increment rate

func _ready():
	points = $PointsLabel
	original_font_color = points.modulate  
	reset()

func reset():
	display_points = 0
	total_points = 0
	points.text = "0"
	points.modulate = original_font_color  # Reset color

func _process(delta):
	if display_points < total_points:
		display_points += increment_rate * delta
		elapsed_time += delta

		# Handle the scale change
		if elapsed_time >= increase_time / 20.0:
			elapsed_time = 0.0
			if current_scale_state == ScaleState.INCREASE:
				self.scale += Vector2(scale_delta, scale_delta)
				current_scale_state = ScaleState.DECREASE
			else:
				self.scale -= Vector2(scale_delta, scale_delta)
				current_scale_state = ScaleState.INCREASE

		points.text = str(int(display_points))

		# To make sure display_points don't overshoot total_points
		if display_points >= total_points:
			points.modulate =  original_font_color  # Reset color
			display_points = total_points
			points.text = str(int(display_points))
			set_process(false)

func update_points(new_points: int):
	total_points = new_points
	var point_difference = total_points - display_points
	increment_rate = point_difference / increase_time

	# Determine color based on whether it's an increase or decrease
	if total_points > display_points:
		points.modulate = IncreaseColor
	else:
		points.modulate = DecreaseColor

	set_process(true)  # Make sure process is running
