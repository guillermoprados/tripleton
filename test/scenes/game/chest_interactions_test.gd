# GdUnit generated TestSuite
class_name ChestInteractionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__action_bomb_on_chest_should_open_chest_and_restore_floating_token() -> void:
	
	var landscape := [
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
		[ID_EMPTY,ID_CHE_B,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_BOMBB)
	
	var test_cell = Vector2(3,1)
	
	# move over
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_invalid_cell_conditions(test_cell)
	
	# try to place
	await __async_move_mouse_to_cell(test_cell, true)
	# __assert_floating_token_is_in_spawn_position()
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()
	
	# assert_array(board.cell_tokens_ids).contains_same_exactly(
	#	[
	#		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	#		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	#		[ID_EMPTY,ID_EMPTY,ID_EMPTY],
	#		[ID_EMPTY,ID_CHE_B,ID_EMPTY],
	#	]
	#)
	
	assert_int(game_manager.points).is_equal(0)


