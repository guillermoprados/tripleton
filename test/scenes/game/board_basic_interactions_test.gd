# GdUnit generated TestSuite
class_name BoardBasicInteractionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__move_over_cells() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	__set_floating_token(runner, ID_GRASS)

	var test_cell_in = Vector2(0,1)
	var test_cell_out = Vector2(2,1)
	
	var cell := board.get_cell_at_position(test_cell_in)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)
	
	await __async_move_mouse_to_cell(test_cell_in, false)
	
	await __async_await_for_enum(cell, "highlight", Constants.CellHighlight.VALID, enum_is_equal, 5)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.VALID)
	
	await __async_move_mouse_to_cell(test_cell_out, false)
	await __async_await_for_enum(cell, "highlight", Constants.CellHighlight.NONE, enum_is_equal, 5)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)
	
func test__place_single_token() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	__set_floating_token(runner, ID_GRASS)
	
	var test_cell = Vector2(1,2)
	var cell := board.get_cell_at_position(test_cell)
	assert_bool(board.is_cell_empty(test_cell)).is_true()
	
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	assert_object(game_manager.get_floating_token()).is_null()
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(test_cell)).is_false()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_GRASS],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__try_to_place_token_in_occupied_slot() -> void:
	
	var test_cell = Vector2(1,2)
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_GRASS],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	## second token (BUSH)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_BUSHH)
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_GRASS],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
