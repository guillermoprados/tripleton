# GdUnit generated TestSuite
class_name DifficultiesDataTests
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_loading_a_difficulty_easy_it_should_match_config_data() -> void:
	
	await __set_to_player_state()
	var config_difficulty : Dictionary = __game_config_data.get_difficulties_config_data(Constants.DifficultyLevel.EASY)
	var game_difficulty: Difficulty = game_manager.difficulty
	var difficulty_name: String = Difficulty.as_string(Constants.DifficultyLevel.EASY)
	assert_that(game_difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_difficulty.save_token_slots).is_equal(config_difficulty["save_token_slots"])
	assert_int(game_difficulty.max_level_token).is_equal(config_difficulty["max_level_token"])
	assert_str(game_difficulty.max_level_chest_id).is_equal(config_difficulty["max_level_chest_id"])
	
	assert_array(game_difficulty.__tokens_set.__common_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__frequent_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__rare_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__scarce_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__unique_token_ids).is_not_empty()

func test__when_loading_a_difficulty_hard_it_should_match_config_data() -> void:
	
	await __set_to_player_state()
	var config_difficulty : Dictionary = __game_config_data.get_difficulties_config_data(Constants.DifficultyLevel.HARD)
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	
	var game_difficulty: Difficulty = game_manager.difficulty
	var difficulty_name: String = Difficulty.as_string(Constants.DifficultyLevel.HARD)
	assert_that(game_difficulty.level).is_equal(Constants.DifficultyLevel.HARD)
	assert_int(game_difficulty.save_token_slots).is_equal(config_difficulty["save_token_slots"])
	assert_int(game_difficulty.max_level_token).is_equal(config_difficulty["max_level_token"])
	assert_str(game_difficulty.max_level_chest_id).is_equal(config_difficulty["max_level_chest_id"])
	
	assert_array(game_difficulty.__tokens_set.__common_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__frequent_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__rare_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__scarce_token_ids).is_not_empty()
	assert_array(game_difficulty.__tokens_set.__unique_token_ids).is_not_empty()
