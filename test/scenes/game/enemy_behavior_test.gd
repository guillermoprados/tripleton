# GdUnit generated TestSuite
class_name EnemyBehabiorTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func __paralized_enemies(paralized:bool) -> void:
	for token in board.get_tokens_of_type(Constants.TokenType.ENEMY):
		var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
		for key in enemies:
			enemies[key].behavior.paralize = paralized
	
func test__monokelo_will_jump_to_empty_cell() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
	]
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	#prepare landscape
	
	## set Monokelo
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_GRASS,ID_MNKEL,ID_GRASS],
			[ID_GRASS,ID_EMPTY,ID_GRASS],
		]
	)
	
	#check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
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
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	
	## set Monokelo
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	#check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
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
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	__paralized_enemies(true)
	
	## set Monokelo
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(Vector2(2,2), true)
	
	## let them try to move
	__paralized_enemies(false)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
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
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	__paralized_enemies(true)
	
	## set Monokelo area 1
	var area_1_cell := Vector2(3,0)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(area_1_cell, true)
	__paralized_enemies(true)
	
	## set Monokelo area 2
	var area_2_cell := Vector2(0,2)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(area_2_cell, true)
	__paralized_enemies(true)
	
	## set Monokelo area 3
	var area_3_cell := Vector2(0,2)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(area_3_cell, true)
	__paralized_enemies(true)
	
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
	
	await __set_to_player_turn_with_empty_board(landscape, runner)
	__paralized_enemies(true)
	
	## set Monokelo area 1
	var area_1_cell := Vector2(4,0)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MNKEL)
	await __async_move_mouse_to_cell(area_1_cell, true)
	__paralized_enemies(true)

	await __ascync_await_for_time_helper(1)
	assert_that(board.get_token_at_cell(area_1_cell).highlight).is_equal(Constants.TokenHighlight.LAST)

	## set area divider
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_BUSHH)
	await __async_move_mouse_to_cell(Vector2(2,0), true)
	
	await __ascync_await_for_time_helper(2)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var enemy_tokens = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for cell in enemy_tokens.keys():
		assert_that(enemy_tokens[cell].highlight).is_equal(Constants.TokenHighlight.NONE)

## things to test before continuing:

### several enemies in one zone, last one is blue
### several enemies in multiple zones, last one is blue in each one
### join areas
