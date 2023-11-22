# GdUnit generated TestSuite
class_name SpawnTokenSlotTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__on_game_start_should_create_a_token() -> void:
	
	await __set_to_player_state(IDs.BUSHH)
	
	assert_object(game_manager.difficulty).is_not_null()
	var spawned_token = game_manager.spawn_token_slot.spawned_token
	assert_object(spawned_token).is_not_null()
	assert_str(spawned_token.id).is_equal(IDs.BUSHH)
	assert_that(spawned_token.current_status).is_equal(Constants.TokenStatus.BOXED)
	assert_that(spawned_token.position).is_equal(game_manager.spawn_token_slot.position)
	assert_int(spawned_token.z_index).is_equal(Constants.TOKEN_BOXED_Z_INDEX)

	#var back_token = game_manager.spawn_token_slot.back_token
	#assert_object(back_token).is_not_null()
	#assert_that(back_token.current_status).is_equal(Constants.TokenStatus.GHOST_BOX)
	#assert_that(back_token.position).is_equal(game_manager.spawn_token_slot.position)
	#assert_int(back_token.z_index).is_equal(Constants.GHOST_BOX_Z_INDEX)




