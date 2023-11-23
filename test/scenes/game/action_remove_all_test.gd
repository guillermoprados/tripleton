# GdUnit generated TestSuite
class_name ActionRemoveAllTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func __await_assert_cell_remove_conditions(current_id:String, cell_index:Vector2, landscape:Array) -> void:
	for row in range(landscape.size()):
		for col in range(landscape[0].size()):
			var i_cell = Vector2(row, col)
			if current_id == board.cell_tokens_ids[row][col]:
				if cell_index == i_cell:
					await __await_assert_valid_cell_conditions(cell_index)
				else:
					await __await_assert_actionable_conditions(i_cell)
			else:
				await __await_assert_empty_cell_conditions(i_cell)
			
func test__action_should_remove_all_same_normal_token() -> void:
	
	var landscape := [
		[IDs.BUSHH,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.BUSHH],
		[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
		[IDs.BUSHH,IDs.GRASS,IDs.TREEE],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
	
	var test_cell = Vector2(3,0)
	
	## move over the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_cell_remove_conditions(IDs.BUSHH, test_cell, landscape)	

	## run action
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
			[IDs.EMPTY,IDs.GRASS,IDs.TREEE],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)


func test__action_should_kill_all_enemies_of_the_same_type() -> void:
	
	var landscape := [
		[IDs.BUSHH,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.MNKEL,IDs.GRASS,IDs.MNKEL],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
	
	var test_cell = Vector2(0,1)
	
	## move over the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_cell_remove_conditions(IDs.MNKEL, test_cell, landscape)	
	
	## run action
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()

	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.BUSHH,IDs.GRAVE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.GRAVE,IDs.GRASS,IDs.GRAVE],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
	
func test__action_should_remove_on_chests() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
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

func test__action_remove_on_prize_should_be_invalid() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.PR_CA,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
	
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
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
	
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

func test__action_should_remove_even_when_there_is_one_token() -> void:
	
	var landscape := [
		[IDs.BUSHH,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.LAMPP],
		[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
		[IDs.BUSHH,IDs.GRASS,IDs.TREEE],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.REMOV)
	
	var test_cell = Vector2(1,2)
	
	## move over the token
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_cell_remove_conditions(IDs.LAMPP, test_cell, landscape)	

	## run action
	await __async_move_mouse_to_cell(test_cell, true)
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.BUSHH,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
			[IDs.BUSHH,IDs.GRASS,IDs.TREEE],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)
