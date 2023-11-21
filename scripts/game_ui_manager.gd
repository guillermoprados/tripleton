extends Node

class_name GameUIManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func adjust_board_position(board:Board) -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var board_size: Vector2 = Vector2(board.columns * Constants.CELL_SIZE.x, board.rows * Constants.CELL_SIZE.y)
	
	board.position.x = (screen_size.x / 2 ) - (board_size.x / 2)
	board.position.y = screen_size.y  - board_size.y - Constants.BOARD_BOTTOM_SEPARATION

func adjust_save_token_slots_positions(save_token_slots:Array[SaveTokenSlot]) -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var slots_total_width = (Constants.CELL_SIZE.x * save_token_slots.size()) + \
							Constants.SAVE_SLOT_INTER_SEPARATION * (save_token_slots.size() - 1)
	
	var slot_pos : Vector2
	slot_pos.x = screen_size.x - slots_total_width
	slot_pos.y = screen_size.y - Constants.SAVE_SLOT_BOTTOM_SEPARATION - Constants.CELL_SIZE.y
	for i in range(save_token_slots.size()):
		save_token_slots[i].position = slot_pos
		save_token_slots[i].z_index = Constants.TOKEN_BOX_Z_INDEX 
