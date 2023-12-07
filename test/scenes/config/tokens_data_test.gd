# GdUnit generated TestSuite
class_name TokensDataTests
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_loading_a_chest_token_it_should_configure_it_config_data() -> void:
	
	await __set_to_player_state(IDs.CHE_B)
	
	var token_data := game_manager.initial_token_slot.token.data
	var is_chest := token_data is TokenChestData
	assert_bool(is_chest).is_true()
	
	var chest_token_data := token_data as TokenChestData
	var random_token_id := chest_token_data.get_random_prize_id()
	assert_str(random_token_id).is_not_empty()
	
func test__when_loading_a_combinable_token_it_should_configure_it_config_data() -> void:
	
	await __set_to_player_state(IDs.BUSHH)
	
	var token_data := game_manager.initial_token_slot.token.data
	var is_combinable := token_data is TokenCombinableData
	assert_bool(is_combinable).is_true()
	
	var config_token_data : Dictionary = __game_config_data.get_token_config_data(IDs.BUSHH)
	var combinable_data := token_data as TokenCombinableData
	var prize_data := token_data as TokenPrizeData
	
	assert_str(combinable_data.next_token_id).is_equal(config_token_data["next_token_id"])
	assert_str(Utils.reward_type_as_string(prize_data.reward_type)).is_equal(config_token_data["reward_type"])
	assert_int(prize_data.reward_value).is_equal(config_token_data["reward_value"])
	
func test__when_loading_a_collectable_tokens_it_should_configure_it_config_data() -> void:
	
	await __set_to_player_state(IDs.CHE_B)
	
	var token_data := game_manager.initial_token_slot.token.data
	var is_combinable := token_data is TokenCombinableData
	assert_bool(is_combinable).is_true()
	
	var config_token_data : Dictionary = __game_config_data.get_token_config_data(IDs.CHE_B)
	
	assert_int(int(token_data.is_collectable)).is_equal(config_token_data["collectable"])
	
