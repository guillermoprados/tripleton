# GdUnit generated TestSuite
class_name DifficultiesTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_game_starts_points_should_be_cero() -> void:
	
	await __set_to_player_state()
	
	assert_int(game_manager.points).is_zero()
	assert_object(game_manager.difficulty).is_not_null()
	assert_int(game_manager.difficulty_manager.diff_points).is_zero()

func test__when_points_added_difficulty_must_update_points() -> void:
	
	await __set_to_player_state()
	
	game_manager.add_points(150)
	
	assert_int(game_manager.points).is_equal(150)
	assert_int(game_manager.difficulty_manager.diff_points).is_equal(150)
	
func test__when_points_excedded_diff_max_points_it_should_switch_to_next_diff() -> void:
	
	await __set_to_player_state()
	
	assert_str(game_manager.difficulty.name).is_equal("Easy")
	
	var diff_points := game_manager.difficulty.total_points
	
	game_manager.add_points(diff_points + 10)
	assert_str(game_manager.difficulty.name).is_equal("Medium")
	assert_int(game_manager.points).is_equal(diff_points + 10)
	assert_int(game_manager.difficulty_manager.diff_points).is_equal(10)

func test__when_points_excedded_diff_max_points_on_last_diff_it_should_stay() -> void:
	
	await __set_to_player_state()
	
	assert_str(game_manager.difficulty.name).is_equal("Easy")
	
	var diff_points := game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_str(game_manager.difficulty.name).is_equal("Medium")
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_str(game_manager.difficulty.name).is_equal("Hard")
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_str(game_manager.difficulty.name).is_equal("Hard")


func test__easy_diff_should_use_default_chest_bronze() -> void:
	
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	assert_str(game_manager.difficulty.name).is_equal("Easy")
	assert_int(game_manager.difficulty.max_level_token).is_equal(2)
	
	## add grass
	await __wait_to_next_player_turn(IDs.TREEE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__medium_diff_should_use_default_chest_bronze() -> void:
	
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY],
		[IDs.EMPTY,IDs.B_TRE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var diff_points := game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_str(game_manager.difficulty.name).is_equal("Medium")
	assert_int(game_manager.difficulty.max_level_token).is_equal(3)
	
	## add grass
	await __wait_to_next_player_turn(IDs.B_TRE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)
