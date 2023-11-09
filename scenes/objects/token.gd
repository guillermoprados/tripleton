extends Node2D

class_name Token

@export var color_highlight_last : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_transparent : Color = Color(1, 1, 1, 0.5)

@export var tweener:TokenTweener

var sprite_holder:TokenSpriteHolder

var behavior: TokenBehavior
var action: TokenAction
var data:TokenData
var created_at:float
var current_status : Constants.TokenStatus 

var _set_data_status: Constants.TokenStatus

var id:String:
	get:
		return data.id

var type:Constants.TokenType:
	get:
		return data.type()	

var is_ready: bool:
	get:
		return is_node_ready() and sprite_holder.is_node_ready()
				
var is_boxed: bool:
	get:
		return current_status == Constants.TokenStatus.BOXED
		
var is_floating: bool:
	get:
		return current_status == Constants.TokenStatus.FLOATING
	
var is_placed: bool:
	get:
		return current_status == Constants.TokenStatus.PLACED

var is_in_range: bool:
	get:
		return current_status == Constants.TokenStatus.IN_RANGE

var is_invisible: bool:
	get:
		return current_status == Constants.TokenStatus.INVISIBLE

# not used yet
var floor_type:Constants.FloorType:
	get:
		return data.floor_type()	
		
func _init():
	created_at = Time.get_unix_time_from_system()

func _process(delta:float) -> void:
	pass

func set_data(token_data:TokenData, status:Constants.TokenStatus) -> void:
	id = token_data.id
	data = token_data
	_set_data_status = status
	sprite_holder = token_data.sprite_scene.instantiate()
	sprite_holder.ready.connect(__sprite_node_ready)
	add_child(sprite_holder)
	for child in sprite_holder.get_children():
		if child is TokenBehavior:
			behavior = child
		if child is TokenAction:
			action = child
		
func __sprite_node_ready() -> void:
	set_status(_set_data_status)
		
func set_status(new_status:Constants.TokenStatus) -> void:
	assert(current_status != new_status, "Trying to set the same status")
	
	if current_status == Constants.TokenStatus.IN_RANGE:
		tweener.clear_in_range()

	current_status = new_status
	match current_status:
		Constants.TokenStatus.BOXED:
			sprite_holder.set_boxed()		
		Constants.TokenStatus.FLOATING:
			sprite_holder.set_floating()		
		Constants.TokenStatus.PLACED:
			sprite_holder.set_placed()
		Constants.TokenStatus.IN_RANGE:
			sprite_holder.set_in_range()
		Constants.TokenStatus.INVISIBLE:
			sprite_holder.set_invisible()

func unhighlight() -> void:
	highlight(Constants.TokenHighlight.NONE)
	
func highlight(mode:Constants.TokenHighlight) -> void:
	if true:
		return
		
	match mode:
		Constants.TokenHighlight.NONE:
			sprite_holder.sprite.modulate = Color.WHITE
		Constants.TokenHighlight.INVALID:
			sprite_holder.sprite.modulate = color_highlight_invalid
		Constants.TokenHighlight.LAST:
			sprite_holder.sprite.modulate = color_highlight_last
		Constants.TokenHighlight.TRANSPARENT:
			sprite_holder.sprite.modulate = color_highlight_transparent

func set_in_range(difference_pos:Vector2) -> void:
	set_status(Constants.TokenStatus.IN_RANGE)
	tweener.set_in_range_tweener(difference_pos)
