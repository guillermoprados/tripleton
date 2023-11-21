extends StateBase

class_name StateLoading

@export var ordered_dinasties:Array[Dinasty]
@export var ordered_difficulties:Array[Difficulty]
@export var landscape_tokens:Array[TokenData]
@export var prefill_landscape: bool

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.LOADING

var __inner_state := 0
const STATE_PREPARE := 0
const STATE_SET_OBJECTS := 1
const STATE_PREPARE_LANDSCAPE := 2
const STATE_CONFIG := 3
const STATE_PREPARE_UI := 4
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
		STATE_SET_OBJECTS:
			__position_game_objects()
		STATE_CONFIG:
			assert(ordered_dinasties.size() > 0, "Add dinasties")
			game_manager.dinasty_manager.set_dinasties(ordered_dinasties)
			assert(ordered_difficulties.size() > 0, "Add difficulties")
			game_manager.difficulty_manager.set_difficulties(ordered_difficulties)
		STATE_PREPARE_LANDSCAPE:
			__create_landscape()
		STATE_PREPARE_UI:
			game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
		STATE_READY:
			state_finished.emit(id)
	
	__inner_state += 1
	
func __position_game_objects() -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var board_size: Vector2 = Vector2(board.columns * Constants.CELL_SIZE.x, board.rows * Constants.CELL_SIZE.y)
	
	board.position.x = (screen_size.x / 2 ) - (board_size.x / 2)
	board.position.y = screen_size.y  - board_size.y - Constants.BOARD_BOTTOM_SEPARATION
	
	game_manager.spawn_token_cell.position = board.position + (Constants.CELL_SIZE / 2)
	game_manager.spawn_token_cell.position.y -= (Constants.CELL_SIZE.y * Constants.BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER)
	game_manager.spawn_token_cell.z_index = Constants.CELL_Z_INDEX
	
	game_manager.save_token_cell.position = board.position + (Constants.CELL_SIZE / 2)
	game_manager.save_token_cell.position.y -= (Constants.CELL_SIZE.y * Constants.BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER)
	game_manager.save_token_cell.position.x += board_size.x - Constants.CELL_SIZE.x
	game_manager.save_token_cell.z_index = Constants.CELL_Z_INDEX
	
func __create_landscape() -> void:
	randomize()
	#TODO: DO NOT PLACE ENEMIES IN ENCLOSED PLACES!!
	var rand_num = get_random_between(Constants.MIN_LANDSCAPE_TOKENS, Constants.MAX_LANDSCAPE_TOKENS)
	for i in range(rand_num + 1):  # +1 to make it inclusive of the random number
		var random_cell:Vector2 = get_random_position(board.rows, board.columns)
		if board.is_cell_empty(random_cell):
			var rand_token = get_random_between(0, landscape_tokens.size() - 1)
			var random_token_data:TokenData = landscape_tokens[rand_token]
			var random_token = game_manager.instantiate_new_token(random_token_data, Constants.TokenStatus.PLACED)
			board.set_token_at_cell(random_token, random_cell)

func get_random_between(min_val: int, max_val: int) -> int:
	return min_val + randi() % (max_val - min_val + 1)

func get_random_position(rows: int, columns: int) -> Vector2:
	var rand_row = randi() % rows
	var rand_col = randi() % columns
	return Vector2(rand_row, rand_col)

func is_landscape_created() -> bool:
	return __inner_state > STATE_PREPARE_LANDSCAPE
