extends Node2D

class_name SpawnTokenSlot

@export_category("Packed Scenes")
@export var token_scene: PackedScene

signal on_slot_entered(index:int)
signal on_slot_selected(index:int)

@export_category("Internal Dependencies")
@export var cell_board:BoardCell
@export var background:Sprite2D

var __spawned_token:BoardToken
var spawned_token:BoardToken:
	get:
		return __spawned_token

var __ghost_token:BoardToken
var gosth_back_token:BoardToken:
	get:
		return __ghost_token
		
func _ready():
	background.z_index = Constants.BOARD_Z_INDEX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_new_random_token(difficulty:Difficulty) -> void:
	assert(not __spawned_token, "trying to spawn a token when there is already one")
	spawn_new_token(difficulty.get_random_token_data())
	
func spawn_new_token(token_data:TokenData) -> void:
	assert(not __spawned_token, "trying to spawn a token when there is already one")
	var new_token := token_scene.instantiate() as BoardToken
	new_token.set_data(token_data, Constants.TokenStatus.BOXED)
	box_token(new_token, false)

func discard_token() -> void:
	assert(__spawned_token, "cannot discard token if there isn't one")
	remove_child(__spawned_token)
	__spawned_token.queue_free()
	__spawned_token = null

func box_token(to_box_token:BoardToken, animated:bool = false) -> void:
	assert(not __spawned_token, "trying to spawn a token when there is already one")
	__spawned_token = to_box_token	
	add_child(__spawned_token)
	spawned_token.z_index = Constants.TOKEN_BOXED_Z_INDEX
	if animated:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(spawned_token, "position", self.position, 0.2)	
	else:
		spawned_token.position = Vector2.ZERO
	
func __set_back_token_for_token(token:BoardToken) -> void:
	var new_token := token_scene.instantiate() as BoardToken
	#__back_token = instantiate_new_token(token_data, Constants.TokenStatus.GHOST_BOX)
	#add_child(ghost_token)
	#ghost_token.position = spawn_token_cell.position
	#ghost_token.z_index = Constants.GHOST_BOX_Z_INDEX
