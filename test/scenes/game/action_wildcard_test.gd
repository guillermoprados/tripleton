# GdUnit generated TestSuite
class_name ActionWildcardTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_combine_two_tokens() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	
	var test_cell = Vector2(3,0)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_BUSHH,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(points_per_id[ID_GRASS] * 3)

func test__action_combine_two_groups_tokens() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_BUSHH,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(points_per_id[ID_GRASS] * 5)

func test__action_should_combine_escalated_levels() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_GRASS,ID_EMPTY,ID_BUSHH],
		[ID_GRASS,ID_EMPTY,ID_BUSHH],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_TREEE,ID_EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[ID_GRASS] * 3)
	expected_points += (points_per_id[ID_BUSHH] * 3)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

func test__action_should_chose_bigger_combinations() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_LAMPP,ID_LAMPP],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_BUSHH,ID_BUSHH],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	
	var test_cell = Vector2(2,1)
	
	assert_int(points_per_id[ID_BUSHH]).is_greater(points_per_id[ID_LAMPP])
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_LAMPP,ID_LAMPP],
			[ID_EMPTY,ID_TREEE,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[ID_BUSHH] * 3)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

func test__action_cannot_be_placed_over_other_tokens() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_MNKEL,ID_EMPTY],
		[ID_EMPTY,ID_CHE_B,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	__paralized_enemies(true)
	
	var enemy_cell = Vector2(0,1)
	var chest_cell = Vector2(1,1)
	var grass_cell = Vector2(2,1)
	
	## enemy cell the token
	await __async_move_mouse_to_cell(enemy_cell, false)
	await __await_assert_invalid_cell_conditions(enemy_cell)
	await __async_move_mouse_to_cell(enemy_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	## chest cell the token
	await __async_move_mouse_to_cell(chest_cell, false)
	await __await_assert_invalid_cell_conditions(chest_cell)
	await __async_move_mouse_to_cell(chest_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	## grass cell the token
	await __async_move_mouse_to_cell(grass_cell, false)
	await __await_assert_invalid_cell_conditions(grass_cell)
	await __async_move_mouse_to_cell(grass_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_MNKEL,ID_EMPTY],
			[ID_EMPTY,ID_CHE_B,ID_EMPTY],
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_be_wasted_if_no_combination() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_MNKEL,ID_EMPTY],
		[ID_GRASS,ID_CHE_B,ID_EMPTY],
		[ID_BUSHH,ID_GRASS,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_WILDC)
	__paralized_enemies(true)
	
	var test_cell := Vector2(0,2)
	
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_MNKEL,ID_ROCKK],
			[ID_GRASS,ID_CHE_B,ID_EMPTY],
			[ID_BUSHH,ID_GRASS,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
