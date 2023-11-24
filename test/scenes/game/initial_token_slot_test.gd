# GdUnit generated TestSuite
class_name InitialTokenSlotTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__on_game_start_should_create_a_token() -> void:
	
	await __set_to_player_state(IDs.BUSHH)
	
	assert_object(game_manager.difficulty).is_not_null()
	var spawned_token = game_manager.initial_token_slot.token
	assert_object(spawned_token).is_not_null()
	assert_str(spawned_token.id).is_equal(IDs.BUSHH)
	assert_that(spawned_token.current_status).is_equal(Constants.TokenStatus.BOXED)
	assert_that(spawned_token.position).is_equal(Vector2.ZERO)
	assert_int(spawned_token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)
	assert_bool(spawned_token.z_as_relative).is_false()

	var gosth_back_token = game_manager.initial_token_slot.back_token
	assert_object(gosth_back_token).is_not_null()
	assert_str(gosth_back_token.id).is_equal(IDs.BUSHH)
	assert_that(gosth_back_token.current_status).is_equal(Constants.TokenStatus.GHOST_BOX)
	assert_that(gosth_back_token.position).is_equal(Vector2.ZERO)
	assert_int(gosth_back_token.z_index).is_equal(Constants.GHOST_BOX_Z_INDEX)
	assert_bool(gosth_back_token.z_as_relative).is_false()

func test__discard_token_should_clean_both_fron_and_back_token() -> void:
	await __set_to_player_state()
	game_manager.initial_token_slot.discard_token()
	var spawned_token = game_manager.initial_token_slot.token
	assert_object(spawned_token).is_null()
	var gosth_back_token = game_manager.initial_token_slot.back_token
	assert_object(gosth_back_token).is_null()

func test__when_picking_up_a_token_token_should_be_null_but_ghost_should_remain() -> void:
	
	await __set_to_player_state(IDs.BUSHH)
	
	var picked_token := game_manager.initial_token_slot.pick_token() 
	game_manager.add_child(picked_token)
	assert_str(picked_token.id).is_equal(IDs.BUSHH)
	
	var spawned_token = game_manager.initial_token_slot.token
	assert_object(spawned_token).is_null()
	
	var gosth_back_token = game_manager.initial_token_slot.back_token
	assert_object(gosth_back_token).is_not_null()
	assert_str(gosth_back_token.id).is_equal(IDs.BUSHH)
	
	assert_object(picked_token.get_parent()).is_not_same(gosth_back_token.get_parent())
	
