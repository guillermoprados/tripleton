extends Node2D

class_name InitialTokenSlot

@export_category("Packed Scenes")
@export var token_scene: PackedScene

signal on_slot_entered(index:int)
signal on_slot_selected(index:int)

@export_category("Internal Dependencies")
@export var cell_board:BoardCell
@export var background:Sprite2D

var __animate_to_pos := false

var __token:BoardToken
var token:BoardToken:
	get:
		return __token
	set(value):
		assert(not value.get_parent(), "cannot set a token with a parent")
		assert(not token, "cannot set a token if there is already one")
		__token = value
		add_child(token)
		token.position = Vector2.ZERO
		token.set_status(Constants.TokenStatus.BOXED)
		token.z_index = Constants.TOKEN_BOXED_Z_INDEX
		set_boxed_token_back(token)

var __ghost_token:BoardToken
var back_token:BoardToken:
	get:
		return __ghost_token
		
func _ready() -> void:
	background.z_index = Constants.BOARD_Z_INDEX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if __animate_to_pos:
		var tween := create_tween()
		tween.set_parallel(false)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(token, "position", Vector2.ZERO, 0.2)	
		__animate_to_pos = false
	pass

func spawn_random_token(difficulty:Difficulty) -> void:
	spawn_token(difficulty.get_random_token_data())
	
func spawn_token(token_id:String) -> void:
	var new_token := token_scene.instantiate() as BoardToken
	new_token.set_data(token_id, Constants.TokenStatus.NONE)
	new_token.z_as_relative = false
	token = new_token

func discard_token() -> void:
	if __token:
		remove_child(__token)
		__token.queue_free()
		__token = null
	if __ghost_token:
		remove_child(__ghost_token)
		__ghost_token.queue_free()
		__ghost_token = null

func return_token(to_box_token:BoardToken, box_token_world_position:Vector2) -> void:
	token = to_box_token
	if box_token_world_position != Vector2.ZERO:
		var fixed_pos := box_token_world_position - position
		token.position = fixed_pos
		__animate_to_pos = true
	
func pick_token() -> BoardToken:
	assert(token, "you cannot pick on an empty slot")
	
	var picked_token := token
	remove_child(token)
	__token = null
	return picked_token
	
	
func set_boxed_token_back(token:BoardToken) -> void:
	
	if __ghost_token:
		remove_child(__ghost_token)
		__ghost_token.queue_free()
		__ghost_token = null
	
	__ghost_token = token_scene.instantiate() as BoardToken
	add_child(__ghost_token)
	back_token.z_index = Constants.GHOST_BOX_Z_INDEX
	back_token.z_as_relative = false
	back_token.set_data(token.id, Constants.TokenStatus.GHOST_BOX)
	

func _on_area_2d_cell_entered(index):
	pass # Replace with function body.


func _on_area_2d_cell_exited(index):
	pass # Replace with function body.

func _on_area_2d_cell_selected(index):
	pass # Replace with function body.
