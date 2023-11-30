# GdUnit generated TestSuite
class_name GravesCombinationTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__grave_to_tomb() -> void:
	
	var landscape := [
		[IDs.GRAVE,IDs.GRAVE,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.GRAVE)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.TOMBB],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.GRAVE] * 3)

func test__tomb_to_shrine() -> void:
	
	var landscape := [
		[IDs.TOMBB,IDs.TOMBB,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.TOMBB)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.SRINE],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.TOMBB] * 3)

func test__shrine_to_chest_silver() -> void:
	
	var landscape := [
		[IDs.SRINE,IDs.SRINE,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.SRINE)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.CHE_S],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.SRINE] * 3)
