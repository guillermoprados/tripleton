extends StateBase

class_name StateIntro

@export var landscape_tokens:TokensSet

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.INTRO

var create_landscape:bool
	
func _on_state_entered() -> void:
	create_landscape = true
	
# override in states
func _on_state_exited() -> void:
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.INTRO)
	game_manager.gameplay_ui.fade_to_transparent()

func _process(delta:float) -> void:
	if create_landscape:
		__create_landscape()
		create_landscape = false
	else:
		state_finished.emit(id)

func __create_landscape() -> void:
	randomize()
	var rand_num = get_random_between(Constants.MIN_LANDSCAPE_TOKENS, Constants.MAX_LANDSCAPE_TOKENS)
	for i in range(rand_num + 1):  # +1 to make it inclusive of the random number
		var random_cell:Vector2 = get_random_position(board.rows, board.columns)
		var random_token_data:TokenData = landscape_tokens.get_random_token_data()
		var random_token = game_manager.instantiate_new_token(random_token_data, Vector2.ZERO, null)
		if board.is_cell_empty(random_cell):
			board.set_token_at_cell(random_token, random_cell)

func get_random_between(min_val: int, max_val: int) -> int:
	return min_val + randi() % (max_val - min_val + 1)

func get_random_position(rows: int, columns: int) -> Vector2:
	var rand_row = randi() % rows
	var rand_col = randi() % columns
	return Vector2(rand_row, rand_col)
