extends Sprite2D

class_name MenuCloud

@export var cloud_textures : Array[Texture]

@export var min_time : float
@export var max_time : float

var cloud_tween : Tween
var screen_size:Vector2
var total_x: float

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	total_x = screen_size.x * 2
	start_movement()
	
func get_random_start_position() -> Vector2:
	var pos_x := - total_x/2
	var pos_y := randf_range(0 + screen_size.y *.2, screen_size.y + screen_size.y *.2 )
	pos_y -= get_parent().position.y
	return Vector2(pos_x,pos_y)
	
func _on_tween_completed()->void:
	position =  get_random_start_position()
	await get_tree().create_timer(randf_range(0,2)).timeout
	start_movement()

func reset_tweeners() -> void:
	if cloud_tween and cloud_tween.is_running():
		cloud_tween.kill()
	cloud_tween = null
	cloud_tween = create_tween()
	
func start_movement() -> void:
	
	z_index = randf_range(-10, -2)	
	
	if cloud_textures.size() > 0:
		texture = cloud_textures[randi() % cloud_textures.size()]

	var time := randf_range(min_time, max_time)

	# Move the cloud to the opposite side
	reset_tweeners()
	cloud_tween.tween_property(self, "position:x", position.x + total_x, time)
	cloud_tween.tween_callback(_on_tween_completed)
