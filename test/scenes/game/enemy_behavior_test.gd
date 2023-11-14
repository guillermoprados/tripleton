# GdUnit generated TestSuite
class_name EnemyBehabiorTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

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
	pass
## things to test before continuing:

### several enemies in one zone, last one is blue
### several enemies in multiple zones, last one is blue in each one
### several enemies die in one place (6 at least), just one chest on place
