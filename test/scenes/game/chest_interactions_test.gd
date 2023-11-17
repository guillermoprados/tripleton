# GdUnit generated TestSuite
class_name ChestInteractionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__normal_token_cannot_be_placed_over_chest_and_should_open() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	__paralized_enemies(true)
	
	var chest_cell = Vector2(1,1)
	
	var ID__PRIZE := __get_chest_prize_id_at_cell(chest_cell)
	
	## chest cell the token should open
	await __async_move_mouse_to_cell(chest_cell, false)
	await __await_assert_invalid_cell_conditions(chest_cell)
	await __async_move_mouse_to_cell(chest_cell, true)
	await __await_assert_floating_token_is_boxed()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,ID__PRIZE,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_normal_token_on_chest_should_be_invalid() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	
	var chest_cell = Vector2(3,1)
	var ID__PRIZE := __get_chest_prize_id_at_cell(chest_cell)
	
	## chest cell the token should open
	await __async_move_mouse_to_cell(chest_cell, false)
	await __await_assert_invalid_cell_conditions(chest_cell)
	await __async_move_mouse_to_cell(chest_cell, true)
	await __await_assert_floating_token_is_boxed()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,ID__PRIZE,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
