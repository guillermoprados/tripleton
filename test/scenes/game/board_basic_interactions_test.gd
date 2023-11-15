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
	
	await __set_to_player_state_with_board(landscape, ID_GRASS)
	
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
	
	await __set_to_player_state_with_board(landscape, ID_GRASS)
	
	var test_cell = Vector2(1,2)
	var cell := board.get_cell_at_position(test_cell)
	assert_bool(board.is_cell_empty(test_cell)).is_true()
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	## check
	await __wait_to_next_player_turn()
	
	assert_bool(board.is_cell_empty(test_cell)).is_false()
	assert_object(game_manager.get_floating_token()).is_not_null()
	assert_bool(board.enabled_interaction).is_true()
	
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
	
	await __set_to_player_state_with_board(landscape)
	
	## second token (BUSH)
	await __wait_to_next_player_turn(ID_BUSHH)
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_GRASS],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	## should let the player continue playing
	assert_bool(board.enabled_interaction).is_true()
	assert_int(game_manager.points).is_equal(0)
