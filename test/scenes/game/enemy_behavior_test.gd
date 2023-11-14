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
	
	## Monokelo
	var initial_pos = Vector2(0,1)
	var final_pos = Vector2(0,0)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, ID_MONOKELO)
	await __async_move_mouse_to_cell(initial_pos, true)
	
	#check
	# assert_bool(board.is_cell_empty(initial_pos)).is_false()
	# assert_bool(board.is_cell_empty(final_pos)).is_true()
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	
	# assert_bool(board.is_cell_empty(initial_pos)).is_true()
	# assert_bool(board.is_cell_empty(final_pos)).is_false()
		
	var token = board.get_token_at_cell(final_pos)
	# assert_str(token.id).is_equal(ID_MONOKELO)
	
	await __ascync_await_for_time_helper(5)
