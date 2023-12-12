extends Node2D

class_name MainMenuBackground

const FROM_SKY_ANIM_TIME = 2
const TO_CITY_ANIM_TIME = 1
const SCALE_FACTOR_TO_FRONT = 1.5

@export var menu_mountains:Array[MenuMountain]
@export var menu_clouds:Array[MenuCloud]

@export var markers:Array[Marker2D] = []

var markers_original_positions:Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for marker:Marker2D in markers:
		markers_original_positions.append(marker.position)
	
	get_viewport().size_changed.connect(__adjust_markers_positions)
	__adjust_markers_positions()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass
	
	
func __adjust_markers_positions() -> void:
	var scale_factor:Vector2 = get_tree().root.content_scale_size
	var screen_size:Vector2 = get_viewport().get_visible_rect().size
	
	# original_pos --> scale_factor
	# new_pos --> screen_size
	for i in range(markers.size()):
		markers[i].position = screen_size * markers_original_positions[i] / scale_factor


func animate_from_sky() -> void:
	for mountain:MenuMountain in menu_mountains:
		mountain.animate_from_button(FROM_SKY_ANIM_TIME)

func animate_to_city() -> void:
	for mountain:MenuMountain in menu_mountains:
		mountain.animate_to_front(SCALE_FACTOR_TO_FRONT, TO_CITY_ANIM_TIME)
	for cloud:MenuCloud in menu_clouds:
		cloud.animate_to_front(SCALE_FACTOR_TO_FRONT, TO_CITY_ANIM_TIME)
