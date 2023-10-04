extends Control

class_name PointsCounter

var label:Label
var icon:TextureRect

var display_points: float = 0
var total_points: int = 0

@export var icon_texture: Texture

@export var increase_time: float = 1.0  # Time to go from display_points to total_points
@export var scale_delta: float = 0.1  # Amount by which scale will change

# New color exports
@export var DecreaseColor: Color = Color(1, 0, 0)  # Default to red
@export var IncreaseColor: Color = Color(0, 1, 0)  # Default to green

var elapsed_time: float = 0.0
var original_font_color: Color

enum ScaleState {
	INCREASE,
	DECREASE
}

var current_scale_state = ScaleState.INCREASE

var increment_rate: float = 0.0  # This will be our constant increment rate

func _ready():
	label = $Label
	icon = $Icon
	original_font_color = label.modulate  
	if icon_texture:
		icon.texture = icon_texture
	reset()

func reset():
	display_points = 0
	total_points = 0
	label.text = "0"
	label.modulate = original_font_color  # Reset color

func _process(delta):
	if display_points < total_points:
		display_points += increment_rate * delta
		elapsed_time += delta

		# Handle the scale change
		if elapsed_time >= increase_time / 20.0:
			elapsed_time = 0.0
			if current_scale_state == ScaleState.INCREASE:
				label.scale += Vector2(scale_delta, scale_delta)
				current_scale_state = ScaleState.DECREASE
			else:
				label.scale -= Vector2(scale_delta, scale_delta)
				current_scale_state = ScaleState.INCREASE

		label.text = str(int(display_points))

		# To make sure display_points don't overshoot total_points
		if display_points >= total_points:
			label.modulate =  original_font_color  # Reset color
			display_points = total_points
			label.text = str(int(display_points))
			set_process(false)

func update_points(new_points: int):
	total_points = new_points
	var point_difference = total_points - display_points
	increment_rate = point_difference / increase_time

	# Determine color based on whether it's an increase or decrease
	if total_points > display_points:
		label.modulate = IncreaseColor
	else:
		label.modulate = DecreaseColor

	set_process(true)  # Make sure process is running
