# GdUnit generated TestSuite
class_name TokenCombinationTest
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
	
	await __ascync_await_for_enum(cell, "highlight", Constants.CellHighlight.VALID, enum_is_equal, 5)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.VALID)
	
	await __async_move_mouse_to_cell(test_cell_out, false)
	await __ascync_await_for_enum(cell, "highlight", Constants.CellHighlight.NONE, enum_is_equal, 5)
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
	
	var token := board.get_token_at_cell(test_cell)
	assert_object(token).is_not_null()
	assert_str(token.id).is_equal(ID_GRASS)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__try_to_place_token_in_occupied_slot() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	var test_cell = Vector2(1,2)
	
	## first token
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(test_cell, true)
	
	## second token (BUSH)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_BUSHH)
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var token := board.get_token_at_cell(test_cell)
	assert_str(token.id).is_equal(ID_GRASS)
	assert_int(game_manager.points).is_equal(0)
	
func test__try_single_level_combination() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(ID_GRASS).reward_value
	
	## first token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	var first_cell = Vector2(0,0)
	await __async_move_mouse_to_cell(first_cell, true)
	
	## second token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	var second_cell = Vector2(0,1)
	await __async_move_mouse_to_cell(second_cell, true)
	
	## third token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	var third_cell = Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(first_cell)).is_true()
	assert_bool(board.is_cell_empty(second_cell)).is_true()
	assert_bool(board.is_cell_empty(third_cell)).is_false()
	
	var token = board.get_token_at_cell(third_cell)
	assert_str(token.id).is_equal(ID_BUSHH)
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(grass_points * 3)

func test__try_multi_level_combination() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(ID_GRASS).reward_value
	var bush_points : int = __all_token_data.get_token_data_by_id(ID_BUSHH).reward_value
	
	## grass level
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_1 = Vector2(0,0)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(cell_1, true)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_2 = Vector2(0,1)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(cell_2, true)
	
	## bush level
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_3 = Vector2(1,0)
	__set_floating_token(runner, ID_BUSHH)
	await __async_move_mouse_to_cell(cell_3, true)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_4 = Vector2(2,0)
	__set_floating_token(runner, ID_BUSHH)
	await __async_move_mouse_to_cell(cell_4, true)
	
	## add grass
	var cell_5 := Vector2(1,1)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(cell_5, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(cell_1)).is_true()
	assert_bool(board.is_cell_empty(cell_2)).is_true()
	assert_bool(board.is_cell_empty(cell_3)).is_true()
	assert_bool(board.is_cell_empty(cell_4)).is_true()
	assert_bool(board.is_cell_empty(cell_5)).is_false()

	var token = board.get_token_at_cell(cell_5)
	assert_str(token.id).is_equal(ID_TREEE)
	
	var expected_points = (grass_points * 3) + (bush_points * 3)
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)
