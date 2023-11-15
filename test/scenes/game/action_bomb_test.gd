# GdUnit generated TestSuite
class_name ActionBombTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_bomb_should_destroy_a_normal_token() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_BOMBB)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	__assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_bomb_should_kill_an_enemy() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_MNKEL,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_BOMBB)
	__paralized_enemies(true)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	__assert_valid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_GRAVE,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__action_bomb_should_destroy_chest() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_CHE_B,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_BOMBB)
	
	var test_cell = Vector2(3,1)
	
	## place the token
	await __async_move_mouse_to_cell(test_cell, false)
	__assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_ROCKK,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_bomb_wasted_should_set_it_to_rock() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_BOMBB)
	
	var test_cell = Vector2(3,1)
	
	## move to token
	await __async_move_mouse_to_cell(test_cell, false)
	__assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_EMPTY,ID_EMPTY],
			[ID_EMPTY,ID_ROCKK,ID_EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
