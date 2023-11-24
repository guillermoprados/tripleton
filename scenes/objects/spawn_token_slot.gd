extends Node2D

class_name SpawnTokenSlot

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

var __ghost_token:BoardToken
var back_token:BoardToken:
	get:
		return __ghost_token
		
func _ready():
	background.z_index = Constants.BOARD_Z_INDEX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if __animate_to_pos:
		var tween = create_tween()
		tween.set_parallel(false)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(token, "position", Vector2.ZERO, 0.2)	
		__animate_to_pos = false
	pass

func spawn_random_token(difficulty:Difficulty) -> void:
	assert(not __token, "trying to spawn a token when there is already one")
	spawn_token(difficulty.get_random_token_data())
	
func spawn_token(token_data:TokenData) -> void:
	assert(not __token, "trying to spawn a token when there is already one")
	var new_token := token_scene.instantiate() as BoardToken
	new_token.set_data(token_data, Constants.TokenStatus.NONE)
	new_token.z_as_relative = false
	box_token(new_token, false)

func discard_token() -> void:
	if __token:
		remove_child(__token)
		__token.queue_free()
		__token = null
	if __ghost_token:
		remove_child(__ghost_token)
		__ghost_token.queue_free()
		__ghost_token = null

func box_token(to_box_token:BoardToken, animated:bool = false) -> void:
	assert(not __token, "trying to box a token when there is already one")
	__token = to_box_token	
	
	var token_parent = __token.get_parent()
	var fixed_pos = token.position
	if token_parent:
		fixed_pos = fixed_pos - position
		token_parent.remove_child(__token)
		
	add_child(__token)
	token.set_status(Constants.TokenStatus.BOXED)
	token.z_index = Constants.TOKEN_BOXED_Z_INDEX
	
	set_boxed_token_back(__token)
	
	if animated:
		token.position = fixed_pos
		__animate_to_pos = true
	else:
		token.position = Vector2.ZERO
	
func pick_token() -> BoardToken:
	assert(__token, "you cannot pick on an empty slot")
	
	var picked_token := token
	remove_child(__token)
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
	
	back_token.set_data(token.data, Constants.TokenStatus.GHOST_BOX)
	
