# GdUnit generated TestSuite
class_name SaveSlotsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__slots_should_be_created_on_difficulty_changes() -> void:
	
	await __set_to_player_state()
	
	assert_object(game_manager.difficulty).is_not_null()
	assert_str(game_manager.difficulty.name).is_equal("Easy")
	assert_int(game_manager.difficulty.save_token_slots).is_equal(1)
	
	assert_int(game_manager.save_slots.size()).is_equal(1)
	assert_int(game_manager.save_slots[0].index).is_equal(0)
	assert_bool(game_manager.save_slots[0].is_empty()).is_true()
	assert_bool(game_manager.save_slots[0].enabled).is_true()
	
	game_manager.difficulty_manager.next_difficulty()
	
	assert_str(game_manager.difficulty.name).is_equal("Medium")
	assert_int(game_manager.difficulty.save_token_slots).is_equal(2)
	
	assert_int(game_manager.save_slots.size()).is_equal(2)
	assert_int(game_manager.save_slots[1].index).is_equal(1)
	assert_bool(game_manager.save_slots[1].is_empty()).is_true()
	assert_bool(game_manager.save_slots[1].enabled).is_true()
	
	game_manager.difficulty_manager.next_difficulty()
	
	assert_str(game_manager.difficulty.name).is_equal("Hard")
	assert_int(game_manager.difficulty.save_token_slots).is_equal(3)
	
	assert_int(game_manager.save_slots.size()).is_equal(3)
	assert_int(game_manager.save_slots[2].index).is_equal(2)
	assert_bool(game_manager.save_slots[2].is_empty()).is_true()
	assert_bool(game_manager.save_slots[2].enabled).is_true()

func test__slots_should_be_disabled_when_finish_turn() -> void:
	await __set_to_player_state()
	assert_bool(game_manager.save_slots[0].enabled).is_true()
	#place a token
	await __async_move_mouse_to_cell(Vector2.ZERO, true)
	#await __wait_to_game_state(Constants.PlayingState.ENEMIES)
	assert_bool(game_manager.save_slots[0].enabled).is_false()
	
func test__should_save_token_when_empty() -> void:
	
	await __set_to_player_state(IDs.GRASS)
	
	var save_slot := game_manager.save_slots[0]
	
	assert_bool(save_slot.is_empty()).is_true()
	assert_bool(save_slot.enabled).is_true()
	
	await __await_assert_empty_cell_object_conditions(save_slot.cell_board)
	await __async_move_mouse_to_cell_object(save_slot.cell_board, false)
	await __await_assert_valid_cell_object_conditions(save_slot.cell_board)
