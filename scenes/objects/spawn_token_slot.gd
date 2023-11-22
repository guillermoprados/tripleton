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

func _ready():
	background.z_index = Constants.BOARD_Z_INDEX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_new_token(difficulty:Difficulty) -> void:
	assert(not __spawned_token, "trying to spawn a token when there is already one")
	var new_token := token_scene.instantiate() as BoardToken
	box_token(new_token, false)

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
		spawned_token.position = self.position
	
