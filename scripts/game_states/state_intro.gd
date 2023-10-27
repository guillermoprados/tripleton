extends StateBase

class_name StateIntro

@export var landscape_tokens:TokensSet
@export var prefill_landscape: bool

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.INTRO

var position_game_objects:bool
var create_landscape:bool
var prepare_playing_ui:bool
var prepare_first_dinasty:bool
	
func _on_state_entered() -> void:
	position_game_objects = true
	create_landscape = prefill_landscape
	prepare_playing_ui = true
	prepare_first_dinasty = true
	
# override in states
func _on_state_exited() -> void:
	game_manager.gameplay_ui.fade_to_transparent()

func _process(delta:float) -> void:
	if position_game_objects:
		__position_game_objects()
		position_game_objects = false
	if create_landscape:
		__create_landscape()
		create_landscape = false
	elif prepare_playing_ui:
		game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
		prepare_playing_ui = false
	elif prepare_first_dinasty:
		__set_first_dinasty()
		prepare_first_dinasty = false
	else:
		state_finished.emit(id)

func __position_game_objects() -> void:
	var screen_size:Vector2 = get_tree().root.content_scale_size
	var board_size: Vector2 = Vector2(board.columns * Constants.CELL_SIZE.x, board.rows * Constants.CELL_SIZE.y)
	board.position.x = (screen_size.x / 2 ) - (board_size.x / 2)
	board.position.y = screen_size.y  - board_size.y - Constants.BOARD_BOTTOM_SEPARATION
	
	game_manager.spawn_token_cell.position = board.position
	game_manager.spawn_token_cell.position.y -= (Constants.CELL_SIZE.y * Constants.BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER)
	
	game_manager.save_token_cell.position = board.position
	game_manager.save_token_cell.position.y -= (Constants.CELL_SIZE.y * Constants.BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER)
	game_manager.save_token_cell.position.x += board_size.x - Constants.CELL_SIZE.x
	
func __create_landscape() -> void:
	randomize()
	var rand_num = get_random_between(Constants.MIN_LANDSCAPE_TOKENS, Constants.MAX_LANDSCAPE_TOKENS)
	for i in range(rand_num + 1):  # +1 to make it inclusive of the random number
		var random_cell:Vector2 = get_random_position(board.rows, board.columns)
		var random_token_data:TokenData = landscape_tokens.get_random_token_data()
		var random_token = game_manager.instantiate_new_token(random_token_data)
		if board.is_cell_empty(random_cell):
			board.set_token_at_cell(random_token, random_cell)

func __set_first_dinasty() -> void:
	# I know, I'll call a private method but I know what I'm doing
	game_manager.__go_to_next_dinasty(0)

func get_random_between(min_val: int, max_val: int) -> int:
	return min_val + randi() % (max_val - min_val + 1)

func get_random_position(rows: int, columns: int) -> Vector2:
	var rand_row = randi() % rows
	var rand_col = randi() % columns
	return Vector2(rand_row, rand_col)
