extends StateBase

class_name StateLoading

@export_category("Required Data Configuration")
@export var ordered_difficulties:Array[Difficulty]
@export var landscape_tokens:Array[TokenData]

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.LOADING

var __inner_state := 0
const STATE_PREPARE := 0
const STATE_PREPARE_UI := 1
const STATE_CONFIG := 2
const STATE_SET_OBJECTS := 3
const STATE_PREPARE_LANDSCAPE := 4
const STATE_READY := 5

func _on_state_entered() -> void:
	__inner_state = STATE_PREPARE
	
# override in states
func _on_state_exited() -> void:
	game_manager.gameplay_ui.fade_to_transparent()

func _process(delta:float) -> void:
	match(__inner_state):
		STATE_PREPARE:
			pass
		STATE_CONFIG:
			assert(ordered_difficulties.size() > 0, "Add difficulties")
			game_manager.__set_difficulties(ordered_difficulties)
		STATE_SET_OBJECTS:
			__position_game_objects()
		STATE_PREPARE_LANDSCAPE:
			__create_landscape()
		STATE_PREPARE_UI:
			game_manager.connect_ui()
			game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
		STATE_READY:
			state_finished.emit(id)
	
	__inner_state += 1
	
func __position_game_objects() -> void:
	game_manager.__adjust_board_position()
	game_manager.__adjust_initial_slot_position()
	game_manager.__adjust_save_token_slots_positions()
	
func __create_landscape() -> void:
	randomize()
	#TODO: DO NOT PLACE ENEMIES IN ENCLOSED PLACES!!
	var rand_num := get_random_between(Constants.MIN_LANDSCAPE_TOKENS, Constants.MAX_LANDSCAPE_TOKENS)
	for i in range(rand_num + 1):  # +1 to make it inclusive of the random number
		var random_cell:Vector2 = get_random_position(board.rows, board.columns)
		if board.is_cell_empty(random_cell):
			var rand_token := get_random_between(0, landscape_tokens.size() - 1)
			var random_token_id:String = landscape_tokens[rand_token].id
			var random_token := game_manager.instantiate_new_token(random_token_id, Constants.TokenStatus.PLACED)
			board.set_token_at_cell(random_token, random_cell)

func get_random_between(min_val: int, max_val: int) -> int:
	return min_val + randi() % (max_val - min_val + 1)

func get_random_position(rows: int, columns: int) -> Vector2:
	var rand_row := randi() % rows
	var rand_col := randi() % columns
	return Vector2(rand_row, rand_col)

func is_landscape_created() -> bool:
	return __inner_state > STATE_PREPARE_LANDSCAPE
