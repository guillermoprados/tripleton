
extends Node2D

class_name SaveTokenSlot

signal on_slot_entered(index:int)
signal on_slot_selected(index:int)

var index : int

@export var cell_board:BoardCell
@export var background:Sprite2D

var __saved_token: BoardToken

var enabled: bool

var saved_token: BoardToken:
	get:
		return __saved_token

func _ready():
	background.z_index = Constants.BOARD_Z_INDEX
	
func is_empty() -> bool:
	return !saved_token 

func save_token(token:BoardToken) -> void:
	assert(is_empty(), "this slot is not empty")
	add_child(token)
	token.set_status(Constants.TokenStatus.BOXED)
	token.z_index = Constants.TOKEN_BOXED_Z_INDEX
	__saved_token = token
	
func pick_token() -> BoardToken:
	assert(not is_empty(), "this slot has no token")
	var pick_token = __saved_token
	remove_child(__saved_token)
	__saved_token = null
	return pick_token

func swap_token(to_swap_token:BoardToken) -> BoardToken:
	var to_get_token
	if saved_token:
		pick_token()
	save_token(to_swap_token)
	return to_get_token

func _on_area_2d_cell_entered(position:Vector2):
	if enabled:
		cell_board.set_highlight(Constants.CellHighlight.VALID)
		on_slot_entered.emit(index)

func _on_area_2d_cell_selected(position:Vector2):
	if enabled:
		on_slot_selected.emit(index)

func _on_area_2d_cell_exited(position:Vector2):
	if enabled:
		cell_board.set_highlight(Constants.CellHighlight.NONE)

