# GdUnit generated TestSuite
class_name ActionWildcardTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_combine_two_tokens() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var test_cell = Vector2(3,0)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.BUSHH,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(points_per_id[IDs.GRASS] * 3)

func test__action_should_combine_chests() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.CHE_B],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var test_cell = Vector2(3,0)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.CHE_S,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(points_per_id[IDs.CHE_B] * 3)
	
func test__action_combine_two_groups_tokens() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.GRASS,IDs.EMPTY,IDs.GRASS],
		[IDs.GRASS,IDs.EMPTY,IDs.GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.BUSHH,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(points_per_id[IDs.GRASS] * 5)

func test__action_should_combine_escalated_levels() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.GRASS,IDs.EMPTY,IDs.BUSHH],
		[IDs.GRASS,IDs.EMPTY,IDs.BUSHH],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[IDs.GRASS] * 3)
	expected_points += (points_per_id[IDs.BUSHH] * 3)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

func test__action_should_chose_bigger_combinations() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.LAMPP,IDs.LAMPP],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.BUSHH,IDs.BUSHH],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var test_cell = Vector2(2,1)
	
	assert_int(points_per_id[IDs.BUSHH]).is_greater(points_per_id[IDs.LAMPP])
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell, Constants.CellHighlight.COMBINATION)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.LAMPP,IDs.LAMPP],
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[IDs.BUSHH] * 3)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

func test__action_cannot_be_placed_over_enemies() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	__paralized_enemies(true)
	
	var enemy_cell = Vector2(0,1)
	
	## enemy cell the token
	await __async_move_mouse_to_cell(enemy_cell, false)
	await __await_assert_invalid_cell_conditions(enemy_cell)
	await __async_move_mouse_to_cell(enemy_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_cannot_be_placed_over_normal_tokens() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	__paralized_enemies(true)
	
	var grass_cell = Vector2(2,1)
	
	## grass cell the token
	await __async_move_mouse_to_cell(grass_cell, false)
	await __await_assert_invalid_cell_conditions(grass_cell)
	await __async_move_mouse_to_cell(grass_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__action_cannot_be_placed_over_chest_and_should_open() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	__paralized_enemies(true)
	
	var chest_cell = Vector2(1,1)
	
	var ID__PRIZE := __get_chest_ID__PRIZE_at_cell(chest_cell)
	
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
	
func test__action_cannot_be_placed_over_prize_and_should_pick_it() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.PR_CA,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	
	var prize_cell = Vector2(3,1)
	
	## chest cell the token should open
	await __async_move_mouse_to_cell(prize_cell, false)
	await __await_assert_invalid_cell_conditions(prize_cell)
	await __async_move_mouse_to_cell(prize_cell, true)
	await __await_assert_floating_token_is_boxed()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
func test__action_should_be_wasted_if_no_combination() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
		[IDs.GRASS,IDs.CHE_B,IDs.EMPTY],
		[IDs.BUSHH,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.WILDC)
	__paralized_enemies(true)
	
	var test_cell := Vector2(0,2)
	
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.MNKEL,IDs.ROCKK],
			[IDs.GRASS,IDs.CHE_B,IDs.EMPTY],
			[IDs.BUSHH,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
