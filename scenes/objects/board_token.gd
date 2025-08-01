extends Node2D

class_name BoardToken

@export var color_border_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var color_border_valid : Color = Color(1, 0.5, 0.5, 1)
@export var color_overlay_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var color_border_wasted: Color = Color(1,1,1,1)
@export var color_semi_transparent : Color = Color(1, 1, 1, 0.5)

@export var tweener:TokenTweener
@export var all_tokens_data: GameConfigData

var sprite_holder:TokenSpriteHolder

var behavior: TokenBehavior
var action: TokenAction
var data:TokenData
var created_at:float

var __current_status : Constants.TokenStatus 
var current_status : Constants.TokenStatus:
	get:
		return __current_status

var __highlight : Constants.TokenHighlight 
var highlight : Constants.TokenHighlight:
	get:
		return __highlight

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
		return __current_status == Constants.TokenStatus.BOXED
		
var is_floating: bool:
	get:
		return __current_status == Constants.TokenStatus.FLOATING
	
var is_placed: bool:
	get:
		return __current_status == Constants.TokenStatus.PLACED

var is_in_range: bool:
	get:
		return __current_status == Constants.TokenStatus.IN_RANGE

var is_invisible: bool:
	get:
		return __current_status == Constants.TokenStatus.INVISIBLE

var is_wildcard: bool:
	get:
		return type == Constants.TokenType.ACTION and action.get_type() == Constants.ActionType.WILDCARD
# not used yet
var floor_type:Constants.FloorType:
	get:
		return data.floor_type()	
		
func _init() -> void:
	created_at = Time.get_unix_time_from_system()

func _process(delta:float) -> void:
	pass

func set_data(token_id:String, status:Constants.TokenStatus) -> void:
	var token_data:TokenData = all_tokens_data.get_token_data_by_id(token_id)
	assert(token_data, "Cannot find token data for id:"+token_id)
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
	# assert(__current_status != new_status, "Trying to set the same status")
	
	if __current_status == Constants.TokenStatus.IN_RANGE:
		tweener.clear_in_range()

	if __current_status == Constants.TokenStatus.FLOATING:
		tweener.clear_focused()

	__current_status = new_status
	match __current_status:
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
		Constants.TokenStatus.GHOST_BOX:
			sprite_holder.set_as_box_ghost()

func set_highlight(mode:Constants.TokenHighlight) -> void:
	
	__highlight = mode
	var color:Color = Color.WHITE
	
	# this deserves a rethink
	match mode:
		
		Constants.TokenHighlight.NONE:
			sprite_holder.paint_normal()
		Constants.TokenHighlight.FOCUSED:
			if __current_status == Constants.TokenStatus.FLOATING:
				sprite_holder.paint_floating(Color.WHITE, Color.WHITE)
			if __current_status == Constants.TokenStatus.BOXED:
				sprite_holder.paint_boxed_selected(Color.WHITE, Color.WHITE)
			tweener.set_focus_tweener()	
		Constants.TokenHighlight.VALID:
			assert(__current_status == Constants.TokenStatus.FLOATING, "only floating tokens can be transparent")
			sprite_holder.paint_valid_action(color_border_valid, color_semi_transparent)
		Constants.TokenHighlight.INVALID:
			assert(__current_status == Constants.TokenStatus.FLOATING, "only floating tokens can be invalid")
			sprite_holder.paint_floating(color_border_invalid, color_overlay_invalid )
		Constants.TokenHighlight.WASTED:
			sprite_holder.paint_floating(color_border_wasted, Color.WHITE)
		Constants.TokenHighlight.COMBINATION:
			sprite_holder.paint_floating(Color.WHITE, Color.WHITE)
		Constants.TokenHighlight.LAST:
			assert(__current_status == Constants.TokenStatus.PLACED, "only placed tokens can be last")
			sprite_holder.paint_last()
			
func set_in_range(difference_pos:Vector2) -> void:
	set_status(Constants.TokenStatus.IN_RANGE)
	tweener.set_in_range_tweener(difference_pos)

func set_shining() -> void:
	sprite_holder.paint_shining()

func get_other_token_data_util(token_id:String) -> TokenData:
	return all_tokens_data.get_token_data_by_id(token_id)

func combine_to_position(combine_position:Vector2) -> void:
	var move_tween := create_tween()
	move_tween.tween_property(self, "position", combine_position, .1)
	move_tween.tween_callback(queue_free)
