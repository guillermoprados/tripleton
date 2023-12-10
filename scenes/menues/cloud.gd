extends Sprite2D

@export var left_top_marker : Marker2D
@export var right_bottom_marker : Marker2D

@export var cloud_textures : Array[Texture]

@export var min_time : float
@export var max_time : float

var cloud_tween : Tween
	
func _ready() -> void:
	# Wait randomly between 0 and 2 seconds to become visible
	start_movement()

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

	# Set the initial position based on the chosen side
	if side == 0:
		position.x = left_top_marker.position.x
	else:
		position.x = right_bottom_marker.position.x

	# Set the y position randomly between the specified markers
	position.y = randf_range(left_top_marker.position.y, right_bottom_marker.position.y)

	# Set the texture randomly from the cloud_textures array
	if cloud_textures.size() > 0:
		texture = cloud_textures[randi() % cloud_textures.size()]

	# Calculate the speed randomly between min_speed and max_speed
	var time := randf_range(min_time, max_time)

	var wait_time := randf_range(0, 2)
	await get_tree().create_timer(wait_time).timeout
	
	visible = true
	
	cloud_tween = create_tween()
	
	# Move the cloud to the opposite side
	cloud_tween.set_ease(Tween.EASE_IN_OUT)
	
	if side == 0:
		cloud_tween.tween_property(self, "position", Vector2(right_bottom_marker.position.x, self.position.y), time)
	else:
		cloud_tween.tween_property(self, "position", Vector2(left_top_marker.position.x, self.position.y), time)

	# Connect the tween's "tween_completed" signal to the _on_tween_completed method
	cloud_tween.tween_callback(_on_tween_completed)
