extends Sprite2D

class_name MenuMountain

@export var normal_position_marker: Marker2D
@export var bottom_position_marker: Marker2D
@export var front_position_marker: Marker2D

var  animation_tween: Tween

func reset_tweeners() -> void:
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()
	animation_tween = create_tween()
	
func _ready() -> void:
	pass
			 	
func animate_from_button(time:float) -> void:
	reset_tweeners()
	position = bottom_position_marker.position
	animation_tween.tween_property(self, "position", normal_position_marker.position, time)
	
func animate_to_front(scale_factor:float, time:float) -> void:
	reset_tweeners()
	animation_tween.set_parallel(true)
	animation_tween.tween_property(self, "position", front_position_marker.position, time)
	animation_tween.tween_property(self, "scale", Vector2(scale_factor, scale_factor), time)
