extends Node2D

class_name MainMenuBackground

@export var game_logo:Sprite2D

signal  from_sky_animation_finished()
signal  to_city_animation_finished()

const FROM_SKY_ANIM_TIME = 4
const TO_CITY_ANIM_TIME = 1
const SCALE_FACTOR_TO_FRONT = 1.5

var background_movables:Array
var logo_tween: Tween

func _ready() -> void:
	var screen_size:Vector2 = get_viewport().get_visible_rect().size
	game_logo.position.x = screen_size.x / 2
	background_movables = get_tree().get_nodes_in_group("movable_menu_items")
	__reset_logo_tween()
	
func __reset_logo_tween() -> void:
	if logo_tween:
		logo_tween.kill()
	logo_tween = create_tween()
	
func animate_from_sky() -> void:
	
	for movable:MenuBackgroundMovable in background_movables:
		movable.animate_from_button(FROM_SKY_ANIM_TIME)
	game_logo.scale = Vector2.ZERO
	__reset_logo_tween()
	logo_tween.set_trans(Tween.TRANS_BACK)
	logo_tween.set_ease(Tween.EASE_OUT)
	logo_tween.tween_property(game_logo, "scale", Vector2.ONE, 1.5)
	
func animate_to_city() -> void:
	for movable:MenuBackgroundMovable in background_movables:
		movable.animate_to_front(SCALE_FACTOR_TO_FRONT, TO_CITY_ANIM_TIME)
	__reset_logo_tween()
	logo_tween.set_trans(Tween.TRANS_BACK)
	logo_tween.set_ease(Tween.EASE_IN)
	logo_tween.tween_property(game_logo, "scale", Vector2.ZERO, 0.5)
