# GdUnit generated TestSuite
class_name GameOverConditionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__if_there_are_available_cells_it_should_not_game_over() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.BUSHH)
	
	## place the token
	await __async_move_mouse_to_cell(Vector2(3,2), true)
	
	## cycle and check
	await __wait_to_game_state(Constants.PlayingState.PLAYER)
	
	assert_that(state_machine.current_state).is_equal(Constants.PlayingState.PLAYER)
	
func test__if_there_are_no_available_cells_it_should_game_over() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.BUSHH)
	
	## place the token
	await __async_move_mouse_to_cell(Vector2(3,2), true)
	
	## check
	await __wait_to_game_state(Constants.PlayingState.GAME_OVER)
	
	assert_that(state_machine.current_state).is_equal(Constants.PlayingState.GAME_OVER)

func test__if_the_last_movement_generates_empty_spaces_should_not_gameover() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.BUSHH],
		[IDs.GRASS,IDs.BUSHH,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.BUSHH)
	
	## place the token
	await __async_move_mouse_to_cell(Vector2(3,2), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.GRASS,IDs.GRASS,IDs.GRASS],
			[IDs.GRASS,IDs.GRASS,IDs.GRASS],
			[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
			[IDs.GRASS,IDs.EMPTY,IDs.TREEE],
		]
	)
	
	assert_that(state_machine.current_state).is_equal(Constants.PlayingState.PLAYER)
