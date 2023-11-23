
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
	token.get_parent().remove_child(token)
	add_child(token)
	token.set_status(Constants.TokenStatus.BOXED)
	token.z_index = Constants.TOKEN_BOXED_Z_INDEX
	token.position = Vector2.ZERO
	__saved_token = token
	
func pick_token() -> BoardToken:
	assert(not is_empty(), "this slot has no token")
	var pick_token = __saved_token
	remove_child(__saved_token)
	__saved_token = null
	return pick_token

func swap_token(to_save_token:BoardToken) -> BoardToken:
	assert(not is_empty(), "Cannot swap if there is no token")
	# first get the parent of the saving token and assign it to the picked token
	var picked_token := pick_token()
	var external_parent = to_save_token.get_parent()
	save_token(to_save_token)	
	external_parent.add_child(picked_token)
	picked_token.set_status(Constants.TokenStatus.FLOATING)
	picked_token.z_index = Constants.FLOATING_Z_INDEX
	picked_token.position = self.position - Constants.SAVE_SLOT_OVER_POS
	return picked_token

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

