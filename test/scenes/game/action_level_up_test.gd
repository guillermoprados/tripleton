# GdUnit generated TestSuite
class_name ActionLevelUpTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_should_level_up_combinable_token() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_LV_UP)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
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
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_not_level_up_if_next_token_is_chest() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_B_TRE,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_LV_UP)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_invalid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_B_TRE,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_not_level_up_on_not_normal_tokens() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_MNKEL,ID_EMPTY],
		[ID_EMPTY,ID_CHE_B,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_LV_UP)
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
	await __await_assert_valid_cell_conditions(grass_cell)
	await __async_move_mouse_to_cell(grass_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_MNKEL,ID_EMPTY],
			[ID_EMPTY,ID_CHE_B,ID_EMPTY],
			[ID_EMPTY,ID_BUSHH,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_level_waste_on_empty_cell() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_LV_UP)
	
	var test_cell = Vector2(1,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_ROCKK,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_should_level_up_and_combine() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_BUSHH,ID_BUSHH,ID_TREEE],
		[ID_EMPTY,ID_GRASS,ID_TREEE],
	]
	
	await __set_to_player_state_with_board(landscape, ID_LV_UP)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_B_TRE,ID_EMPTY],
		]
	)
	
	var expected_points = 0
	expected_points += (points_per_id[ID_BUSHH] * 3)
	expected_points += (points_per_id[ID_TREEE] * 3)
	
	assert_int(game_manager.points).is_equal(expected_points)
