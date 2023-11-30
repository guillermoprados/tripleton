# GdUnit generated TestSuite
class_name TokenCombinationTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__grass_to_bush() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.GRASS)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.GRASS] * 3)

func test__bush_to_tree() -> void:
	
	var landscape := [
		[IDs.BUSHH,IDs.BUSHH,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.BUSHH)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.TREEE],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.BUSHH] * 3)

func test__tree_to_chest__level_limited() -> void:
	
	var landscape := [
		[IDs.TREEE,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.TREEE)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.CHE_B],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.TREEE] * 3)

func test__tree_to_big_tree__no_level_limited() -> void:
	
	var landscape := [
		[IDs.TREEE,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.difficulty_manager.disable_level_limit()
	
	
	## third token
	await __wait_to_next_player_turn(IDs.TREEE)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.B_TRE],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.TREEE] * 3)

func test__big_tree_to_chest_bronze() -> void:
	
	var landscape := [
		[IDs.B_TRE,IDs.B_TRE,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.difficulty_manager.disable_level_limit()
	
	## third token
	await __wait_to_next_player_turn(IDs.B_TRE)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.CHE_B],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[IDs.B_TRE] * 3)
