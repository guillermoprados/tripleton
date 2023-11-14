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
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(ID_GRASS).reward_value
	
	## third token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	var third_cell = Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_BUSHH],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(grass_points * 3)

func test__try_multi_level_combination() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_EMPTY],
		[ID_BUSHH,ID_EMPTY,ID_EMPTY],
		[ID_BUSHH,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id(ID_GRASS).reward_value
	var bush_points : int = __all_token_data.get_token_data_by_id(ID_BUSHH).reward_value
	
	
	## add grass
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_TREEE,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)

	var expected_points = (grass_points * 3) + (bush_points * 3)
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)

# check bigger combination
