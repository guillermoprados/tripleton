# GdUnit generated TestSuite
class_name ActionLevelUpTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_should_level_up_combinable_token() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.BUSHH,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_level_up_to_chest_if_last_token_difficulty() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_not_level_up_if_difficulty_allows() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
	__set_to_last_difficulty()
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__action_should_not_level_up_on_enemies() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	__paralized_enemies(true)
	
	var enemy_cell = Vector2(0,1)
	
	## enemy cell the token
	await __async_move_mouse_to_cell(enemy_cell, false)
	await __await_assert_invalid_cell_conditions(enemy_cell)
	await __async_move_mouse_to_cell(enemy_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.floating_token).is_not_null()

	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__action_should_not_level_up_on_chests() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
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

func test__action_level_up_on_prize_should_be_invalid() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.PR_CA,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
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
	
func test__action_should_level_waste_on_empty_cell() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
	var test_cell = Vector2(1,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.ROCKK,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_level_up_and_combine() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.BUSHH,IDs.BUSHH,IDs.TREEE],
		[IDs.EMPTY,IDs.GRASS,IDs.TREEE],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	__set_to_last_difficulty()
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[IDs.BUSHH] * 3)
	expected_points += (points_per_id[IDs.TREEE] * 3)
	
	assert_int(game_manager.points).is_equal(expected_points)
