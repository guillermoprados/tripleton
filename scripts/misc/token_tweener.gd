extends Node2D

class_name TokenTweener

var __sprite_holder: Node2D

var sprite_holder: Node2D:
	get:
		if not __sprite_holder:
			__sprite_holder = get_parent().sprite_holder
			assert(__sprite_holder, "cannot find sprite holder")
			holder_original_pos = __sprite_holder.position
		return __sprite_holder
	
var holder_tween : Tween

var tween_forward : bool

var holder_original_pos:Vector2

var holder_start_pos:Vector2
var holder_to_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	holder_tween = create_tween()
	holder_tween.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func set_focus_tweener() -> void:
	
	tween_forward = true
	
	animate_focused()

func set_in_range_tweener(difference_pos:Vector2) -> void:
	
	holder_to_pos.x = difference_pos.y / 4
	holder_to_pos.y = difference_pos.x / 4
	holder_start_pos = holder_original_pos
	sprite_holder.position = holder_start_pos
	
	tween_forward = true
	
	animate_in_range()
	
func clear_in_range() -> void:
	sprite_holder.position = holder_original_pos
	kill_tweeners()

func clear_focused() -> void:
	sprite_holder.scale = Vector2.ONE
	kill_tweeners()
	
func kill_tweeners() -> void:
	if holder_tween.is_running():
		holder_tween.kill()
	
func animate_in_range() -> void:
	
	kill_tweeners()
	
	holder_tween = create_tween()
	
	if tween_forward:
		__tween_to("position", holder_start_pos + holder_to_pos, 0.2)
	else:
		__tween_to("position", holder_start_pos, 0.3)
	
	tween_forward = !tween_forward
	holder_tween.tween_callback(animate_in_range)

func animate_focused() -> void:
	
	kill_tweeners()
	
	holder_tween = create_tween()
	
	if tween_forward:
		__tween_to("scale", Vector2(1.05, 1.05), 0.4)
	else:
		__tween_to("scale", Vector2(0.95, 0.95), 0.5)
	
	tween_forward = !tween_forward
	holder_tween.tween_callback(animate_focused)
	
func __tween_to(property:String, holder_to:Vector2, time:float) -> void:
	
	holder_tween.set_ease(Tween.EASE_IN)
	holder_tween.tween_property(sprite_holder, property, holder_to, time)
	
