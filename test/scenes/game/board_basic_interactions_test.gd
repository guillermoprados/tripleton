# GdUnit generated TestSuite
class_name BoardBasicInteractionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__move_over_cells() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	
	var test_cell_empty_1 := Vector2(0,1)
	var test_cell_empty_2 := Vector2(2,1)
	var test_cell_occupied := Vector2(1,1)
	
	var spawned_token := game_manager.initial_token_slot.token
	assert_object(spawned_token).is_not_null()
	assert_that(spawned_token.current_status).is_equal(Constants.TokenStatus.BOXED)
	assert_that(spawned_token.highlight).is_equal(Constants.TokenHighlight.FOCUSED)
	
	assert_that(game_manager.floating_token).is_null()
	
	# test cell is not highlighted
	await __await_assert_empty_cell_conditions(test_cell_empty_1)
	
	# test cell and floating token highlight as valid
	await __async_move_mouse_to_cell(test_cell_empty_1, false)
	await __await_assert_valid_cell_conditions(test_cell_empty_1)
	
	assert_object(game_manager.initial_token_slot.token).is_null()
	
	var floating_token := game_manager.floating_token
	assert_that(floating_token.current_status).is_equal(Constants.TokenStatus.FLOATING)
	assert_that(floating_token.highlight).is_equal(Constants.TokenHighlight.FOCUSED)
	
	# leave cell
	# test cell and floating token highlight as valid
	await __async_move_mouse_to_cell(test_cell_empty_2, false)
	await __await_assert_valid_cell_conditions(test_cell_empty_2)
	
	await __await_assert_empty_cell_conditions(test_cell_empty_1)
	
	# move to occupied cell
	# leave cell
	# test cell and floating token highlight as valid
	await __async_move_mouse_to_cell(test_cell_occupied, false)
	await __await_assert_invalid_cell_conditions(test_cell_occupied)
	assert_that(floating_token.current_status).is_equal(Constants.TokenStatus.FLOATING)
	assert_that(floating_token.highlight).is_equal(Constants.TokenHighlight.INVALID)
	
	
	test_cell_occupied
	
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
	
	assert_int(game_manager.game_points).is_equal(0)
	
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
	assert_int(game_manager.game_points).is_equal(0)
