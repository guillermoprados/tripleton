# GdUnit generated TestSuite
class_name EnemiesManagerTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__if_all_enemies_can_move_it_should_return_an_empty_array() -> void:
	
	var landscape := [
		[IDs.MNKEL,IDs.MNKEL,IDs.EMPTY],
		[IDs.MNKEL,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var stucked_enemies = game_manager.enemies_manager.find_stucked_enemies_cells(board.cell_tokens_ids)

	assert_array(stucked_enemies).is_empty()
