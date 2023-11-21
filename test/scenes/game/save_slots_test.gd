# GdUnit generated TestSuite
class_name SaveSlotsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_game_starts_save_slots_should_be_created() -> void:
	
	await __set_to_player_state()
	
	assert_object(game_manager.difficulty).is_not_null()
	assert_str(game_manager.difficulty.name).is_equal("Easy")
	assert_int(game_manager.difficulty.save_token_slots).is_equal(1)
	
	assert_int(game_manager.save_slots.size()).is_equal(1)

