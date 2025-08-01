# GdUnit generated TestSuite
class_name SaveTokenSlotsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__slots_should_be_created_on_difficulty_changes() -> void:
	
	await __set_to_player_state()
	
	assert_object(game_manager.difficulty).is_not_null()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_manager.difficulty.save_token_slots).is_equal(1)
	
	assert_int(game_manager.save_slots.size()).is_equal(1)
	assert_int(game_manager.save_slots[0].index).is_equal(0)
	assert_bool(game_manager.save_slots[0].is_empty()).is_true()
	assert_bool(game_manager.save_slots[0].enabled).is_true()
	
	while game_manager.difficulty.save_token_slots == 1:
		game_manager.__next_difficulty()
	await await_idle_frame()
	
	assert_int(game_manager.difficulty.save_token_slots).is_equal(2)
	
	assert_int(game_manager.save_slots.size()).is_equal(2)
	assert_int(game_manager.save_slots[1].index).is_equal(1)
	assert_bool(game_manager.save_slots[1].is_empty()).is_true()
	assert_bool(game_manager.save_slots[1].enabled).is_true()
	
	while game_manager.difficulty.save_token_slots == 2:
		game_manager.__next_difficulty()
	await await_idle_frame()
	
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
	
	await __set_to_player_state(IDs.B_TRE) # this is wont happend on the get random token data
	
	var save_slot := game_manager.save_slots[0]
	
	await __await_assert_empty_cell_object_conditions(save_slot.cell_board)
	assert_bool(save_slot.is_empty()).is_true()
	assert_bool(save_slot.enabled).is_true()
	
	# move to slot
	await __async_move_mouse_to_cell_object(save_slot.cell_board, false)
	await __await_assert_valid_cell_object_conditions(save_slot.cell_board)
	assert_that(game_manager.floating_token.position).is_equal(save_slot.position)

	# select
	await __async_move_mouse_to_cell_object(save_slot.cell_board, true)
	assert_bool(save_slot.is_empty()).is_false()
	assert_str(save_slot.token.id).is_equal(IDs.B_TRE)
	assert_that(save_slot.token.position).is_equal(Vector2.ZERO)
	assert_int(save_slot.token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	
	await await_idle_frame()
	
	assert_bool(board.enabled_interaction).is_true()
	await __async_await_for_property(game_manager, "floating_token", null, property_is_equal,2)
	assert_object(game_manager.floating_token).is_null()
	assert_object(game_manager.initial_token_slot.token).is_not_null()

func test__should_increase_properly_when_not_empty() -> void:
	
	await __set_to_player_state(IDs.B_TRE) # this is wont happend on the get random token data
	
	var save_slot := game_manager.save_slots[0]
	
	# select
	await __async_move_mouse_to_cell_object(save_slot.cell_board, true)
	assert_bool(save_slot.is_empty()).is_false()
	assert_str(save_slot.token.id).is_equal(IDs.B_TRE)
	assert_that(save_slot.token.position).is_equal(Vector2.ZERO)
	assert_int(save_slot.token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	
	while game_manager.difficulty.save_token_slots == 1:
		game_manager.__next_difficulty()
	await await_idle_frame()
	
	assert_int(game_manager.difficulty.save_token_slots).is_equal(2)
	
	assert_int(game_manager.save_slots.size()).is_equal(2)
	assert_int(game_manager.save_slots[1].index).is_equal(1)
	assert_bool(game_manager.save_slots[1].is_empty()).is_true()
	assert_bool(game_manager.save_slots[1].enabled).is_true()
	
	assert_str(save_slot.token.id).is_equal(IDs.B_TRE)
	assert_that(save_slot.token.position).is_equal(Vector2.ZERO)
	assert_int(save_slot.token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	
func test__should_swap_when_no_empty() -> void:
	
	var first_token_id := IDs.B_TRE # this is wont happend on the get random token data
	
	await __set_to_player_state(first_token_id) 
	
	var save_slot := game_manager.save_slots[0]
	
	# save the first
	await __async_move_mouse_to_cell_object(save_slot.cell_board, true)
	assert_bool(save_slot.is_empty()).is_false()
	assert_str(save_slot.token.id).is_equal(first_token_id)
	assert_int(save_slot.token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	
	# swap the second one
	var floating_over_pos := save_slot.position - Constants.SAVE_SLOT_OVER_POS
	await __async_move_mouse_to_cell_object(save_slot.cell_board, false)
	var second_token_id := game_manager.floating_token.id
	await __await_assert_valid_cell_object_conditions(save_slot.cell_board)
	assert_that(game_manager.floating_token.position).is_equal(floating_over_pos)
	assert_int(game_manager.floating_token.z_index).is_equal(Constants.FLOATING_Z_INDEX)
	assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.FOCUSED)
	
	await __async_move_mouse_to_cell_object(save_slot.cell_board, true)
	await __await_assert_valid_cell_object_conditions(save_slot.cell_board)
	
	assert_bool(save_slot.is_empty()).is_false()
	assert_str(save_slot.token.id).is_equal(second_token_id)
	assert_int(save_slot.token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	assert_that(save_slot.token.position).is_equal(Vector2.ZERO)
	
	assert_str(game_manager.floating_token.id).is_equal(first_token_id)
	assert_that(game_manager.floating_token.current_status).is_equal(Constants.TokenStatus.FLOATING)
	assert_int(game_manager.floating_token.z_index).is_equal(Constants.FLOATING_Z_INDEX)
	assert_that(game_manager.floating_token.position).is_equal(floating_over_pos)
	assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.FOCUSED)

	assert_bool(game_manager.combinator.is_resetted).is_true()
