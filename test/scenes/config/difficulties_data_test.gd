# GdUnit generated TestSuite
class_name DifficultiesDataTests
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_loading_a_difficulty_it_should_match_config_data() -> void:
	
	await __set_to_player_state()
	var config_difficulty : Dictionary = __game_config_data.get_difficulties_config_data(Constants.DifficultyLevel.EASY)
	var game_difficulty: Difficulty = game_manager.difficulty
	assert_that(game_difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_difficulty.save_token_slots).is_equal(config_difficulty["save_token_slots"])
	assert_int(game_difficulty.max_level_token).is_equal(config_difficulty["max_level_token"])
	assert_str(game_difficulty.max_level_chest_id).is_equal(config_difficulty["max_level_chest_id"])
	
