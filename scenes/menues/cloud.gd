extends Sprite2D

@export var cloud_textures : Array[Texture]

@export var min_time : float
@export var max_time : float

var cloud_tween : Tween
	
func _ready() -> void:
	# Wait randomly between 0 and 2 seconds to become visible
	start_movement()

func get_random_start_position() -> Vector2:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var pos_x := 0 - texture.get_size().x
	var pos_y := randf_range(0 + screen_size.y *.2, screen_size.y + screen_size.y *.2 )
	return Vector2(pos_x,pos_y)
	
func get_random_end_position(initial_pos:Vector2) -> Vector2:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var pos_x := screen_size.x + texture.get_size().x
	var pos_y := initial_pos.y
	return Vector2(pos_x,pos_y)
	
func _on_tween_completed()->void:
	kill_tweeners()
	start_movement()

func kill_tweeners() -> void:
	if cloud_tween and cloud_tween.is_running():
		cloud_tween.kill()
		
func start_movement() -> void:
	visible = false
	
	# Pick a side randomly (0 for left, 1 for right)
	var side := randi() % 2

	var initial_pos := get_random_start_position()
	
	if cloud_textures.size() > 0:
		texture = cloud_textures[randi() % cloud_textures.size()]

	var time := randf_range(min_time, max_time)

	var wait_time := randf_range(0, 2)
	await get_tree().create_timer(wait_time).timeout
	
	position = initial_pos
	
	visible = true
	cloud_tween = create_tween()
	
	# Move the cloud to the opposite side
	cloud_tween.set_ease(Tween.EASE_IN_OUT)
	
	var final_pos := get_random_end_position(initial_pos)
	 
	cloud_tween.tween_property(self, "position", final_pos, time)
	
	# Connect the tween's "tween_completed" signal to the _on_tween_completed method
	cloud_tween.tween_callback(_on_tween_completed)
