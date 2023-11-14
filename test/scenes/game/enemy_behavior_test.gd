# GdUnit generated TestSuite
class_name EnemyBehabiorTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__monokelo_will_jump_to_empty_cell() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	#prepare landscape
	
	## first token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,0), true)
	
	## second token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_BUSH)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## third token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(0,2), true)
	
	## set Monokelo
	var initial_pos = Vector2(0,1)
	var final_pos = Vector2(0,0)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MONOKELO)
	await __async_move_mouse_to_cell(initial_pos, true)
	
	#check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	assert_bool(board.is_cell_empty(initial_pos)).is_true()
	assert_bool(board.is_cell_empty(final_pos)).is_false()
		
	var token = board.get_token_at_cell(final_pos)
	assert_str(token.id).is_equal(ID_MONOKELO)

func test__monokelo_will_die_if_cannot_jump() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	#prepare landscape
	
	## first token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(1,0), true)
	
	## second token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_BUSH)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## third token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_GRASS)
	await __async_move_mouse_to_cell(Vector2(0,1), true)
	
	## set Monokelo
	var cell_test = Vector2(0,0)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MONOKELO)
	await __async_move_mouse_to_cell(cell_test, true)
	
	#check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	assert_bool(board.is_cell_empty(cell_test)).is_false()
		
	var token = board.get_token_at_cell(cell_test)
	assert_str(token.id).is_equal(ID_GRAVE)


func test__multiple_enemies_die_should_be_combined_in_last() -> void:

## things to test before continuing:

### several enemies in one zone, last one is blue
### several enemies in multiple zones, last one is blue in each one
### several enemies die in one place (6 at least), just one chest on place 
