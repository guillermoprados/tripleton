# GdUnit generated TestSuite
class_name EnemyBehaviorTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


func test__enemy_will_not_move_if_paralized() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_GRASS],
		[ID_GRASS,ID_MNKEL,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	__paralized_enemies(true)
	
	## give it a chance to move
	await __wait_to_next_player_turn()
	__paralized_enemies(true)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_GRASS,ID_MNKEL,ID_GRASS],
			[ID_GRASS,ID_EMPTY,ID_GRASS],
		]
	)
	
	#check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_GRASS,ID_MNKEL,ID_GRASS],
			[ID_GRASS,ID_EMPTY,ID_GRASS],
		]
	)
	
func test__monokelo_will_jump_to_empty_cell() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	
	## set Monokelo
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_GRASS,ID_MNKEL,ID_GRASS],
			[ID_GRASS,ID_EMPTY,ID_GRASS],
		]
	)
	
	#check
	
	## give it a chance to move
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_GRASS,ID_EMPTY,ID_GRASS],
			[ID_GRASS,ID_MNKEL,ID_GRASS],
		]
	)

func test__monokelo_will_die_if_cannot_jump() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	
	## set Monokelo
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	#check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_GRASS,ID_GRAVE,ID_GRASS],
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
		]
	)


func test__multiple_enemies_die_should_be_combined_in_last() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_GRASS,ID_MNKEL],
		[ID_GRASS,ID_MNKEL,ID_MNKEL],
		[ID_GRASS,ID_MNKEL,ID_EMPTY],
		[ID_GRASS,ID_MNKEL,ID_MNKEL],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	__paralized_enemies(true)
	
	## set Monokelo
	await __async_move_mouse_to_cell(Vector2(2,2), true)
	
	## let them try to move
	__paralized_enemies(false)
	await __wait_to_next_player_turn()
	
	## check
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_GRASS,ID_EMPTY,ID_EMPTY],
			[ID_GRASS,ID_EMPTY,ID_CHE_B],
			[ID_GRASS,ID_EMPTY,ID_EMPTY],
		]
	)

func test__last_enemy_placed_should_be_highlighted_in_area_with_more_than_2_enemies() -> void:
	
	var landscape := [
		[ID_MNKEL,ID_GRASS,ID_EMPTY,ID_MNKEL],
		[ID_MNKEL,ID_GRASS,ID_EMPTY,ID_MNKEL],
		[ID_EMPTY,ID_GRASS,ID_GRASS,ID_GRASS],
		[ID_EMPTY,ID_GRASS,ID_EMPTY,ID_MNKEL],
		[ID_EMPTY,ID_GRASS,ID_EMPTY,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	__paralized_enemies(true)
	
	## set Monokelo area 1
	var area_1_cell := Vector2(3,0)
	await __async_move_mouse_to_cell(area_1_cell, true)
	__paralized_enemies(true)
	
	## set Monokelo area 2
	var area_2_cell := Vector2(0,2)
	await __wait_to_next_player_turn(ID_MNKEL)
	await __async_move_mouse_to_cell(area_2_cell, true)
	__paralized_enemies(true)
	
	__ascync_await_for_time_helper(2)
	## set Monokelo area 3
	var area_3_cell := Vector2(0,2)
	await __wait_to_next_player_turn(ID_MNKEL)
	await __async_move_mouse_to_cell(area_3_cell, true)
	__paralized_enemies(true)
	
	__ascync_await_for_time_helper(2)
	var enemy_tokens = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for cell in enemy_tokens.keys():
		if cell == area_1_cell or cell == area_2_cell:
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.LAST)
		else:
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.NONE)
	
func test__should_remove_last_highlight_if_area_has_less_at_some_moment() -> void:
	
	var landscape := [
		[ID_MNKEL,ID_EMPTY,ID_EMPTY],
		[ID_MNKEL,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_GRASS],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape,ID_MNKEL)
	__paralized_enemies(true)
	
	## set Monokelo area 1
	var area_1_cell := Vector2(4,0)
	await __async_move_mouse_to_cell(area_1_cell, true)
	__paralized_enemies(true)
	
	await __wait_to_next_player_turn()
	assert_that(board.get_token_at_cell(area_1_cell).highlight).is_equal(Constants.TokenHighlight.LAST)

	## set area divider
	await __wait_to_next_player_turn(ID_BUSHH)
	await __async_move_mouse_to_cell(Vector2(2,0), true)
	
	## check the hihglights
	await __wait_to_next_player_turn()
	
	var enemy_tokens = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for cell in enemy_tokens.keys():
		assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.NONE)

func test__should_set_one_last_highlight_if_area_is_joined() -> void:
	
	var landscape := [
		[ID_MNKEL,ID_MNKEL,ID_MNKEL],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_GRASS,ID_GRASS],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_MNKEL,ID_MNKEL,ID_EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, ID_MNKEL)
	__paralized_enemies(true)
	
	## place one monokelo to highlight:
	var last_cell := Vector2(4,2)
	await __async_move_mouse_to_cell(last_cell, true)
	__paralized_enemies(true)
	
	## ensure only the last one is highlighted
	await __wait_to_next_player_turn(ID_BUSHH)
	var enemy_tokens = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for cell in enemy_tokens.keys():
		if cell == last_cell:
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.LAST)
		else:
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.NONE)
	
	## divide the area
	await __async_move_mouse_to_cell(Vector2(2,0), true)
	
	## check highlights
	await __wait_to_next_player_turn()
	
	for cell in enemy_tokens.keys():
		if cell == last_cell or cell == Vector2(0,2):
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.LAST)
		else:
			assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.NONE)
	
	
