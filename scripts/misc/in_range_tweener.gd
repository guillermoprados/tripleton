extends Node2D

class_name InRangeTweener

@export var sprite_holder: Node2D
@export var shadow: Node2D

var holder_tween : Tween
var shadow_tween : Tween
	
var tween_direction_to_target : bool

var holder_original_pos:Vector2
var shadow_original_pos:Vector2

var holder_start_pos:Vector2
var holder_to_pos:Vector2

var shadow_to_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	holder_tween = create_tween()
	shadow_tween = create_tween()
	holder_original_pos = sprite_holder.position
	shadow_original_pos = shadow.position
	clear_in_range()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_in_range_tweener(difference_pos:Vector2) -> void:
	holder_to_pos.x = difference_pos.y / 4
	holder_to_pos.y = difference_pos.x / 4
	holder_start_pos = holder_original_pos
	holder_start_pos.y -= Constants.TOKEN_IN_RANGE_Y_POS 
	sprite_holder.position = holder_start_pos
	
	shadow_to_pos = holder_to_pos
	shadow.scale = Vector2.ONE * Constants.TOKEN_SHADOW_IN_RANGE_MULTIPLIER 
	
	tween_direction_to_target = true
	
	animate_in_range()
	
func clear_in_range() -> void:
	
	sprite_holder.position = holder_original_pos
	shadow.position = shadow_original_pos
	shadow.scale = Vector2.ONE
	
	kill_tweeners()

func kill_tweeners() -> void:
	if holder_tween.is_running():
		holder_tween.kill()
	if shadow_tween.is_running():
		shadow_tween.kill()
	
func animate_in_range() -> void:
	
	kill_tweeners()
	
	holder_tween = create_tween()
	shadow_tween = create_tween()

	if tween_direction_to_target:
		__tween_to(
			holder_start_pos + holder_to_pos, 
			shadow_original_pos + shadow_to_pos,
			 0.2)
	else:
		__tween_to(holder_start_pos, shadow_original_pos, 0.3)
	
	tween_direction_to_target = !tween_direction_to_target
	
	holder_tween.tween_callback(animate_in_range)
		
func __tween_to(holder_to:Vector2, shadow_to:Vector2, time:float) -> void:
	
	holder_tween.set_ease(Tween.EASE_IN)
	holder_tween.tween_property(sprite_holder, "position", holder_to, time)
	shadow_tween.set_ease(Tween.EASE_IN)
	shadow_tween.tween_property(shadow, "position", shadow_to, time)
	
