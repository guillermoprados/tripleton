extends Node2D

class_name SpawnTokenSlot

@export_category("Packed Scenes")
@export var token_scene: PackedScene

signal on_slot_entered(index:int)
signal on_slot_selected(index:int)

@export_category("Internal Dependencies")
@export var cell_board:BoardCell
@export var background:Sprite2D

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
	pass

func spawn_new_random_token(difficulty:Difficulty) -> void:
	assert(not __token, "trying to spawn a token when there is already one")
	spawn_new_token(difficulty.get_random_token_data())
	
func spawn_new_token(token_data:TokenData) -> void:
	assert(not __token, "trying to spawn a token when there is already one")
	var new_token := token_scene.instantiate() as BoardToken
	new_token.set_data(token_data, Constants.TokenStatus.NONE)
	new_token.z_as_relative = false
	box_token(new_token, false)

func discard_token() -> void:
	assert(__token, "cannot discard token if there isn't one")
	remove_child(__token)
	__token.queue_free()
	__token = null
	remove_child(__ghost_token)
	__ghost_token.queue_free()
	__ghost_token = null

func box_token(to_box_token:BoardToken, animated:bool = false) -> void:
	assert(not __token, "trying to box a token when there is already one")
	__token = to_box_token	
	add_child(__token)
	token.set_status(Constants.TokenStatus.BOXED)
	token.z_index = Constants.TOKEN_BOXED_Z_INDEX
	
	__set_boxed_token_back()
	
	if animated:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(token, "position", self.position, 0.2)	
	else:
		token.position = Vector2.ZERO
	
func pick_token() -> BoardToken:
	assert(__token, "you cannot pick on an empty slot")
	
	var picked_token := token
	remove_child(__token)
	__token = null

	return picked_token
	
	
func __set_boxed_token_back() -> void:
	
	if not back_token:
		__ghost_token = token_scene.instantiate() as BoardToken
		add_child(__ghost_token)
		back_token.z_index = Constants.GHOST_BOX_Z_INDEX
		back_token.z_as_relative = false
	
	back_token.set_data(token.data, Constants.TokenStatus.GHOST_BOX)
