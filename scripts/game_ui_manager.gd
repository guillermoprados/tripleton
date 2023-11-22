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

func adjust_spawn_token_position(spawn_token_slot:SpawnTokenSlot, board:Board) -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	spawn_token_slot.position.x = screen_size.x/2
	spawn_token_slot.position.y = board.position.y - (Constants.CELL_SIZE.y/2) - Constants.SPAWN_TOKEN_SEPARATION

func adjust_save_token_slots_positions(save_token_slots:Array[SaveTokenSlot]) -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var num_of_slots = save_token_slots.size()
	var slots_total_width = (Constants.CELL_SIZE.x * num_of_slots) + \
							Constants.SAVE_SLOT_INTER_SEPARATION * (num_of_slots - 1)
	
	var slot_pos : Vector2
	slot_pos.x = (screen_size.x/2) - (slots_total_width/2) + (Constants.CELL_SIZE.x / 2)
	slot_pos.y = screen_size.y - Constants.SAVE_SLOT_BOTTOM_SEPARATION - (Constants.CELL_SIZE.y / 2)
	for i in range(save_token_slots.size()):
		save_token_slots[i].position = slot_pos
		save_token_slots[i].z_index = Constants.TOKEN_BOX_Z_INDEX 
		slot_pos.x += Constants.CELL_SIZE.x + Constants.SAVE_SLOT_INTER_SEPARATION
		if not save_token_slots[i].is_empty():
			save_token_slots[i].saved_token.position = save_token_slots[i].position
