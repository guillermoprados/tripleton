extends Node2D

class_name MenuBackgroundMovable

enum MovableOrientation {
	CENTER,
	LEFT,
	RIGHT,
}

@export var orientation:MovableOrientation

var normal_position: Vector2
var bottom_position: Vector2
var front_position: Vector2

var  animation_tween: Tween

func _ready() -> void:
	__set_positions()
		
func __set_positions() -> void:
	var screen_size:Vector2 = get_viewport().get_visible_rect().size
	
	normal_position = Vector2(screen_size.x / 2 , screen_size.y)
	front_position = Vector2(screen_size.x / 2 , screen_size.y + (screen_size.y / 10))
	bottom_position = Vector2(screen_size.x / 2 , screen_size.y + (screen_size.y / 2))
	
	var normal_position_x_displacement := screen_size.x/2
	var front_position_x_displacement := normal_position_x_displacement + screen_size.x/4
	
	match  orientation:
		MovableOrientation.CENTER:
			pass
		MovableOrientation.LEFT:
			normal_position.x = normal_position.x - normal_position_x_displacement
			front_position.x = normal_position.x - front_position_x_displacement 
			bottom_position.x = normal_position.x
		MovableOrientation.RIGHT:
			normal_position.x = normal_position.x + normal_position_x_displacement
			front_position.x = normal_position.x + front_position_x_displacement 
			bottom_position.x = normal_position.x
			
	position = normal_position
	
func reset_tweeners() -> void:
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()
	animation_tween = create_tween()
		
func animate_from_button(time:float) -> void:
	reset_tweeners()
	position = bottom_position
	animation_tween.set_trans(Tween.TRANS_LINEAR)
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "position", normal_position, time)
	
func animate_to_front(scale_factor:float, time:float) -> void:
	reset_tweeners()
	animation_tween.set_parallel(true)
	animation_tween.tween_property(self, "position", front_position, time)
	animation_tween.tween_property(self, "scale", Vector2(scale_factor, scale_factor), time)
