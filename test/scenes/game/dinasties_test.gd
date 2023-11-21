# GdUnit generated TestSuite
class_name DinastiesTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_game_starts_points_should_be_cero() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	assert_int(game_manager.points).is_zero()
	assert_object(game_manager.dinasty).is_not_null()
	assert_int(game_manager.dinasty_manager.dinasty_points).is_zero()

func test__when_points_added_dinasty_must_update_points() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	await __set_to_player_state_with_board(landscape)
	
	game_manager.add_points(150)
	assert_int(game_manager.points).is_equal(150)
	assert_int(game_manager.dinasty_manager.dinasty_points).is_equal(150)
	
func test__when_points_excedded_dinasty_should_change_to_next_diff() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var dinasty_0_name = game_manager.dinasty.name
	var dinasty_0_points = game_manager.dinasty.total_points
	assert_str(dinasty_0_name).is_equal(game_manager.dinasty_manager.__dinasties[0].name)
	
	game_manager.add_points(dinasty_0_points + 10)
	
	var dinasty_1_name = game_manager.dinasty.name
	assert_str(dinasty_1_name).is_equal(game_manager.dinasty_manager.__dinasties[1].name)
	assert_str(dinasty_1_name).is_not_equal(dinasty_0_name)
	assert_int(game_manager.points).is_equal(dinasty_0_points + 10)
	assert_int(game_manager.dinasty_manager.dinasty_points).is_equal(10)

func test__when_points_excedded_dinasty_max_points_on_last_dinasty_it_should_stay() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var total_dinasties = game_manager.dinasty_manager.__dinasties.size() 
	game_manager.dinasty_manager.__dinasty_index = total_dinasties - 1
	
	var last_dinasty_name = game_manager.dinasty.name
	var last_dinasty_points = game_manager.dinasty.total_points
	assert_str(last_dinasty_name).is_equal(game_manager.dinasty_manager.__dinasties[total_dinasties-1].name)
	
	game_manager.add_points(last_dinasty_points + 10)
	
	assert_str(game_manager.dinasty.name).is_equal(last_dinasty_name)
	assert_int(game_manager.points).is_equal(last_dinasty_points + 10)
	assert_int(game_manager.dinasty_manager.dinasty_points).is_equal(last_dinasty_points + 10)
