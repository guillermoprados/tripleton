# GdUnit generated TestSuite
class_name BoardBasicInteractionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__move_over_cells() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	
	var test_cell_A := Vector2(0,1)
	var test_cell_B := Vector2(2,1)
	
	# test cell is not highlighted
	await __await_assert_empty_cell_conditions(test_cell_A)
	
	# test cell and floating token highlight as valid
	await __async_move_mouse_to_cell(test_cell_A, false)
	await __await_assert_valid_cell_conditions(test_cell_A)
	
	# leave cell
	# test cell and floating token highlight as valid
	await __async_move_mouse_to_cell(test_cell_B, false)
	await __await_assert_valid_cell_conditions(test_cell_B)
	
	await __await_assert_empty_cell_conditions(test_cell_A)
	
func test__place_single_token() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	
	var test_cell := Vector2(1,2)
	var cell := board.get_cell_at_position(test_cell)
	assert_bool(board.is_cell_empty(test_cell)).is_true()
	await __await_assert_empty_cell_conditions(test_cell)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	## check
	await __wait_to_next_player_turn()
	
	assert_bool(board.is_cell_empty(test_cell)).is_false()
	assert_object(game_manager.initial_token_slot.token).is_not_null()
	assert_bool(board.enabled_interaction).is_true()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__try_to_place_token_in_occupied_slot() -> void:
	
	var test_cell := Vector2(1,2)
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## second token (BUSH)
	await __wait_to_next_player_turn(IDs.BUSHH)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_invalid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	## check
	assert_object(game_manager.floating_token).is_not_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	## should let the player continue playing
	assert_bool(board.enabled_interaction).is_true()
	assert_int(game_manager.points).is_equal(0)
