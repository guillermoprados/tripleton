# GdUnit generated TestSuite
class_name EnemiesHelperTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__if_all_enemies_can_move_it_should_return_an_empty_array() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.MNKEL,IDs.EMPTY],
		[IDs.MNKEL,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_empty()

func test__if_an_enemy_cant_move_it_should_return_an_array_with_the_cell() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_equal([Vector2(0,0)])
	
func test___multiple_enemies_are_in_same_group_but_have_a_way_out() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.EMPTY,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_empty()

func test___multiple_enemies_are_in_same_group_but_dont_have_a_way_out() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_equal(
		[
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(3,0),
		]
	)
	
func test___multiple_enemies_are_in_same_group_but_dont_have_a_way_out_but_one_can_jump() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
		[IDs.MOLEE,IDs.GRASS,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_empty()
	
func test___multiple_enemies_are_in_closed_group_one_can_jump_but__no_more_empty_spaces() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.GRASS],
		[IDs.MNKEL,IDs.GRASS,IDs.GRASS],
		[IDs.MOLEE,IDs.GRASS,IDs.GRASS],
		[IDs.MNKEL,IDs.GRASS,IDs.GRASS],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies := EnemiesHelper.find_stucked_enemies_cells(board)

	assert_array(stucked_enemies).is_equal(
		[
			Vector2(0,0),
			Vector2(1,0),
			Vector2(2,0),
			Vector2(3,0),
		]
	)

func test___should_get_the_enemy_groups_divided_by_areas() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.GRASS,IDs.MNKEL],
		[IDs.EMPTY,IDs.GRASS,IDs.MOLEE],
		[IDs.MOLEE,IDs.GRASS,IDs.EMPTY],
		[IDs.GRASS,IDs.EMPTY,IDs.MNKEL],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var grouped_enemies := EnemiesHelper.find_enclosed_groups(board)

	assert_that(grouped_enemies.size()).is_equal(2)

	assert_array(grouped_enemies[0]).is_equal(
		[
			Vector2(0,0),
			Vector2(2,0)
		],
	)

	assert_array(grouped_enemies[1]).is_equal(
		[
			Vector2(0,2),
			Vector2(1,2),
			Vector2(3,2),
		],
	)
