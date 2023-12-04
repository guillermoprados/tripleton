# GdUnit generated TestSuite
class_name TokensDataTests
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_creating_a_chest_token_it_should_configure_it_config_data() -> void:
	
	await __set_to_player_state(IDs.CHE_B)
	
	var token_data := game_manager.initial_token_slot.token.data
	var is_chest = token_data is TokenChestData
	assert_bool(is_chest).is_true()
	
	var chest_token_data := token_data as TokenChestData
	var config_chest_prizes : Dictionary = __game_config_data.get_chest_prizes_data(IDs.CHE_B)
	
	assert_dict(chest_token_data.prizes).is_same(config_chest_prizes)
	
	
	
