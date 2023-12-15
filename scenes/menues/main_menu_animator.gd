extends Node2D

class_name MainMenuBackground

signal  from_sky_animation_finished()
signal  to_city_animation_finished()

const FROM_SKY_ANIM_TIME = 2
const TO_CITY_ANIM_TIME = 1
const SCALE_FACTOR_TO_FRONT = 1.5

var background_movables:Array

func _ready() -> void:
	background_movables = get_tree().get_nodes_in_group("movable_menu_items")
	
func animate_from_sky() -> void:
	
	for movable:MenuBackgroundMovable in background_movables:
		movable.animate_from_button(FROM_SKY_ANIM_TIME)
	
func animate_to_city() -> void:
	for movable:MenuBackgroundMovable in background_movables:
		movable.animate_to_front(SCALE_FACTOR_TO_FRONT, TO_CITY_ANIM_TIME)
