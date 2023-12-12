extends Node2D

@export var menu_mountains:Array[MenuMountain]

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

