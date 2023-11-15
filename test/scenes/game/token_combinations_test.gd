# GdUnit generated TestSuite
class_name TokenCombinationTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__try_single_level_combination() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(ID_GRASS)
	
	var third_cell = Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_BUSHH],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(points_per_id[ID_GRASS] * 3)

func test__try_multi_level_combination() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_EMPTY],
		[ID_BUSHH,ID_EMPTY,ID_EMPTY],
		[ID_BUSHH,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(ID_GRASS).reward_value
	var bush_points : int = __all_token_data.get_token_data_by_id(ID_BUSHH).reward_value
	
	## add grass
	await __wait_to_next_player_turn(ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_TREEE,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)

	var expected_points = (grass_points * 3) + (bush_points * 3)
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

func test__complicated_conditions_1() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_EMPTY],
		[ID_BUSHH,ID_EMPTY,ID_GRASS],
		[ID_BUSHH,ID_EMPTY,ID_BUSHH],
		[ID_EMPTY,ID_BUSHH,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_TREEE,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_BUSHH],
			[ID_EMPTY,ID_BUSHH,ID_EMPTY],
		]
	)

	var expected_points = 0
	expected_points += (points_per_id[ID_GRASS] * 4)
	expected_points += (points_per_id[ID_BUSHH] * 3)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)


func test__complicated_conditions_2() -> void:
	
	var landscape := [
		[ID_LAMPP,ID_GRASS,ID_LAMPP],
		[ID_BUSHH,ID_EMPTY,ID_GRASS],
		[ID_BUSHH,ID_TREEE,ID_TREEE],
		[ID_BUSHH,ID_TREEE,ID_EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_LAMPP,ID_EMPTY,ID_LAMPP],
			[ID_EMPTY,ID_B_TRE,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY]
		]
	)

	var expected_points = 0
	expected_points += (points_per_id[ID_GRASS] * 3)
	expected_points += (points_per_id[ID_BUSHH] * 4) 
	expected_points += (points_per_id[ID_TREEE] * 4)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)


func test__last_combination_should_evolve_to_chest() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_GRASS],
		[ID_EMPTY,ID_B_TRE,ID_EMPTY],
		[ID_EMPTY,ID_B_TRE,ID_EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(ID_B_TRE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_EMPTY,ID_CHE_B,ID_GRASS],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY]
		]
	)

	var expected_points = points_per_id[ID_B_TRE] * 3
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)
	
func test__level_first_to_last_combinations_should_evolve_to_chest() -> void:
	
	var landscape := [
		[ID_LAMPP,ID_GRASS,ID_GRASS],
		[ID_BUSHH,ID_EMPTY,ID_B_TRE],
		[ID_BUSHH,ID_TREEE,ID_B_TRE],
		[ID_BUSHH,ID_TREEE,ID_EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## add grass
	await __wait_to_next_player_turn(ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_LAMPP,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_CHE_B,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY]
		]
	)

	var expected_points = 0
	expected_points += (points_per_id[ID_GRASS] * 3) 
	expected_points += (points_per_id[ID_BUSHH] * 4)
	expected_points += (points_per_id[ID_TREEE] * 3)
	expected_points += (points_per_id[ID_B_TRE] * 3) 

	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)
	
# check bigger combination
