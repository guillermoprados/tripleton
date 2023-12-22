# GdUnit generated TestSuite
class_name TokenHighlightTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__shining_cells_should_not_be_calculated_before_timeout() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.GRASS,IDs.GRASS],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.GRASS)
	
	## third token
	await_idle_frame()
	
	# skip so it calculates the combinations one by one in each _process
	var number_of_cells := 3 * 4
	for i in range(0, number_of_cells + 5):
		await_idle_frame()
		
	assert_array(game_manager.shining_cells).is_empty()
	
	game_manager.__shine_helper_after_time = 2
	
	await __async_await_for_property(game_manager,"shining_cells",[], property_is_not_equal, 3)


func test__shining_cells_single_level_combination_should_higlight_valid_cells() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
		[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
		[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.GRASS)
	
	game_manager.__shine_helper_after_time = 0
	
	var expected_cells := [Vector2(0, 0), Vector2(0, 1)]	
	await __async_await_for_property(game_manager,"shining_cells", [], property_is_not_equal, 2)
	assert_array(game_manager.shining_cells).contains_same(expected_cells)

func test__shining_cells_multi_level_combination_should_higlight_valid_cells() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
		[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
		[IDs.GRASS,IDs.EMPTY,IDs.BUSHH],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	## third token
	await __wait_to_next_player_turn(IDs.GRASS)
	
	game_manager.__shine_helper_after_time = 0
	
	var expected_cells := [Vector2(0, 0), Vector2(0, 1)]	
	await __async_await_for_property(game_manager,"shining_cells", [], property_is_not_equal, 2)
	assert_array(game_manager.shining_cells).contains_same(expected_cells)
