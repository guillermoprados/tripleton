# GdUnit generated TestSuite
class_name TokenCombinationTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__try_single_level_combination() -> void:
	
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
	
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(points_per_id[IDs.GRASS] * 3)

func test__try_multi_level_combination() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.BUSHH,IDs.EMPTY,IDs.EMPTY],
		[IDs.BUSHH,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(IDs.GRASS).reward_value
	var bush_points : int = __all_token_data.get_token_data_by_id(IDs.BUSHH).reward_value
	
	## add grass
	await __wait_to_next_player_turn(IDs.GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)

	var expected_points :int = (grass_points * 3) + (bush_points * 3)
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)

func test__complicated_conditions_1() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
		[IDs.BUSHH,IDs.EMPTY,IDs.BUSHH],
		[IDs.EMPTY,IDs.BUSHH,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(IDs.GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
			[IDs.EMPTY,IDs.BUSHH,IDs.EMPTY],
		]
	)

	var expected_points := 0
	expected_points += (points_per_id[IDs.GRASS] * 4)
	expected_points += (points_per_id[IDs.BUSHH] * 3)
	
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)


func test__complicated_conditions_2() -> void:
	
	var landscape := [
		[IDs.LAMPP,IDs.GRASS,IDs.LAMPP],
		[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
		[IDs.BUSHH,IDs.TREEE,IDs.TREEE],
		[IDs.BUSHH,IDs.TREEE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	__set_to_last_difficulty()
	## add grass
	await __wait_to_next_player_turn(IDs.GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.LAMPP,IDs.EMPTY,IDs.LAMPP],
			[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

	var expected_points := 0
	expected_points += (points_per_id[IDs.GRASS] * 3)
	expected_points += (points_per_id[IDs.BUSHH] * 4) 
	expected_points += (points_per_id[IDs.TREEE] * 4)
	
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)


func test__if_next_combination_level_is_bigger_than_allowed_should_chest() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_manager.difficulty.max_level_token).is_equal(2)
	
	## add grass
	await __wait_to_next_player_turn(IDs.TREEE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.GRASS],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

	var expected_points :int = points_per_id[IDs.TREEE] * 3
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)
	
func test__last_combination_should_evolve_to_chest() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(IDs.B_TRE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.GRASS],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

	var expected_points:int = points_per_id[IDs.B_TRE] * 3
	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)
	
func test__level_first_to_last_combinations_should_evolve_to_chest() -> void:
	
	var landscape := [
		[IDs.LAMPP,IDs.GRASS,IDs.GRASS],
		[IDs.BUSHH,IDs.EMPTY,IDs.B_TRE],
		[IDs.BUSHH,IDs.TREEE,IDs.B_TRE],
		[IDs.BUSHH,IDs.TREEE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	__set_to_last_difficulty()
	
	## add grass
	await __wait_to_next_player_turn(IDs.GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.LAMPP,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

	var expected_points := 0
	expected_points += (points_per_id[IDs.GRASS] * 3) 
	expected_points += (points_per_id[IDs.BUSHH] * 4)
	expected_points += (points_per_id[IDs.TREEE] * 3)
	expected_points += (points_per_id[IDs.B_TRE] * 3) 

	assert_int(game_manager.game_points).is_not_zero()
	assert_int(game_manager.game_points).is_equal(expected_points)
