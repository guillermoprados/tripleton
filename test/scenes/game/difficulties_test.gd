# GdUnit generated TestSuite
class_name DifficultiesTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test__when_game_starts_points_should_be_cero() -> void:
	
	await __set_to_player_state()
	
	assert_int(game_manager.game_points).is_zero()
	assert_object(game_manager.difficulty).is_not_null()
	assert_int(game_manager.difficulty_points).is_zero()

func test__when_points_added_difficulty_must_update_points() -> void:
	
	await __set_to_player_state()
	
	game_manager.add_points(150)
	
	assert_int(game_manager.game_points).is_equal(150)
	assert_int(game_manager.difficulty_points).is_equal(150)
	
func test__when_points_excedded_diff_max_points_it_should_switch_to_next_diff() -> void:
	
	await __set_to_player_state()
	
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	
	var diff_points := game_manager.difficulty.total_points
	
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.MEDIUM)
	assert_int(game_manager.game_points).is_equal(diff_points + 10)
	assert_int(game_manager.difficulty_points).is_equal(10)

func test__when_points_excedded_diff_max_points_on_last_diff_it_should_stay() -> void:
	
	await __set_to_player_state()
	
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	
	var diff_points := game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.MEDIUM)
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.HARD)
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.SUPREME)
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.LEGENDARY)
	
	diff_points = game_manager.difficulty.total_points
	game_manager.add_points(diff_points + 10)
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.LEGENDARY)
	

func test__difficulties_should_have_the_proper_token_limit() -> void:
	
	await __set_to_player_state()
	
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_manager.difficulty.max_level_token).is_equal(2)

	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.MEDIUM)
	assert_int(game_manager.difficulty.max_level_token).is_equal(3)

	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.HARD)
	assert_int(game_manager.difficulty.max_level_token).is_equal(4)
	
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.SUPREME)
	assert_int(game_manager.difficulty.max_level_token).is_equal(5)
	
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.LEGENDARY)
	assert_int(game_manager.difficulty.max_level_token).is_equal(10)
	
func test__easy_diff_should_use_limit_chest() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
		[IDs.EMPTY,IDs.TREEE,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.EASY)
	assert_int(game_manager.difficulty.max_level_token).is_equal(2)
	
	
	await __wait_to_next_player_turn(IDs.TREEE)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__medium_diff_should_use_limit_chest_bronce() -> void:
		
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.TOWER,IDs.EMPTY],
		[IDs.EMPTY,IDs.TOWER,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.MEDIUM)
	
	await __wait_to_next_player_turn(IDs.TOWER)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__hard_diff_should_use_limit_chest_silver() -> void:
		
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.TOWER,IDs.EMPTY],
		[IDs.EMPTY,IDs.TOWER,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.HARD)
	
	await __wait_to_next_player_turn(IDs.TOWER)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_S,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)
	
func test__supreme_diff_should_use_limit_chest_gold() -> void:
		
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.PALAC,IDs.EMPTY],
		[IDs.EMPTY,IDs.PALAC,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.SUPREME)
	
	await __wait_to_next_player_turn(IDs.PALAC)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.CHE_G,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)
	
func test__legendary_diff_not_limit_combinations() -> void:
		
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.PALAC,IDs.EMPTY],
		[IDs.EMPTY,IDs.PALAC,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape)
	
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	game_manager.__next_difficulty()
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.LEGENDARY)
	
	assert_int(game_manager.difficulty.max_level_token).is_equal(10)
	
	await __wait_to_next_player_turn(IDs.PALAC)
	await __async_move_mouse_to_cell(Vector2(1,1), true)
	
	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.FORTR,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)
