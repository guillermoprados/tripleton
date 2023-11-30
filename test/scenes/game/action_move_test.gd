# GdUnit generated TestSuite
class_name ActionMoveTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const MOVE_UP = Vector2(-1,0)
const MOVE_DOWN = Vector2(1,0)
const MOVE_LEFT = Vector2(0,-1)
const MOVE_RIGHT = Vector2(0,1)

func __await_assert_valid_available_moves(cell_index:Vector2, moves:Array[Vector2]) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.VALID, property_is_equal, 2)
	assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.VALID)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.VALID)
	var expected_moves :Array[Vector2] = [] 
	for move in moves:
		expected_moves.append(cell_index + move)
	
	var token:= game_manager.floating_token
	var action : ActionMove = token.action as ActionMove
	var affected_cells := action.affected_cells(cell_index, board.cell_tokens_ids)
	assert_array(affected_cells).contains_exactly_in_any_order(expected_moves)
	for affected_cell in affected_cells:
		await __await_assert_actionable_conditions(affected_cell)
		
func test__move_cell_valid_moves_on_different_positions() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.EMPTY,IDs.GRASS],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.GRASS,IDs.EMPTY,IDs.GRASS],
		[IDs.GRASS,IDs.GRASS,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var test_cell := Vector2(0,0)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_DOWN, MOVE_RIGHT])
	
	test_cell = Vector2(0,2)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_LEFT, MOVE_DOWN])
	
	test_cell = Vector2(1,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_UP, MOVE_LEFT, MOVE_DOWN, MOVE_RIGHT])
	
	test_cell = Vector2(2,0)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_UP, MOVE_RIGHT])
	
	test_cell = Vector2(2,2)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_UP, MOVE_LEFT, MOVE_DOWN])

	test_cell = Vector2(3,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_valid_available_moves(test_cell, [MOVE_UP, MOVE_RIGHT])	
	
	
func test__move_action_wasted() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.EMPTY,IDs.GRASS],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var test_cell := Vector2(0,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.GRASS,IDs.STONE,IDs.GRASS],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		]
	)
	
func test__move_action_invalid() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.GRASS,IDs.GRASS,IDs.GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var test_cell := Vector2(0,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_invalid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.floating_token).is_not_null()

	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.GRASS,IDs.GRASS,IDs.GRASS],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.GRASS,IDs.GRASS,IDs.GRASS],
		]
	)
	
func test__move_action_selected_should_disable_save_slots() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(0,0)
	var to_cell := Vector2(1,0)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_DOWN, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	await __await_assert_valid_available_moves(token_cell, [MOVE_DOWN, MOVE_RIGHT])
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	
	# check save slots as well
	var save_slots := game_manager.save_slots
	
	for slot in save_slots:
		assert_bool(slot.enabled).is_false()
	
	
func test__move_action_down_selected() -> void:
	
	var landscape := [
		[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(0,0)
	var to_cell := Vector2(1,0)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_DOWN, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	await __await_assert_valid_available_moves(token_cell, [MOVE_DOWN, MOVE_RIGHT])
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_not_null()
	
	await __async_move_mouse_to_cell(to_cell, true)
	await __await_token_id_at_cell(IDs.GRASS,to_cell)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__move_action_up_selected() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(2,1)
	var to_cell := Vector2(1,1)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_not_null()
	
	await __async_move_mouse_to_cell(to_cell, true)
	await __await_token_id_at_cell(IDs.GRASS,to_cell)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__move_action_left_selected() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(2,1)
	var to_cell := Vector2(2,0)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_not_null()
	
	await __async_move_mouse_to_cell(to_cell, true)
	await __await_token_id_at_cell(IDs.GRASS,to_cell)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.GRASS,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)
	
func test__move_action_right_selected() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(2,1)
	var to_cell := Vector2(2,2)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_not_null()
	
	await __async_move_mouse_to_cell(to_cell, true)
	await __await_token_id_at_cell(IDs.GRASS,to_cell)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.GRASS],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

func test__move_action_should_combine() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.GRASS,IDs.BUSHH],
		[IDs.BUSHH,IDs.EMPTY,IDs.GRASS],
		[IDs.BUSHH,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	
	var token_cell := Vector2(2,1)
	var to_cell := Vector2(1,1)
	await __async_move_mouse_to_cell(token_cell, false)
	await __await_assert_valid_available_moves(token_cell, [MOVE_UP, MOVE_DOWN, MOVE_RIGHT])
	await __async_move_mouse_to_cell(token_cell, true)
	
	# disables the board but enable just the cells
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.floating_token).is_not_null()
	
	await __async_move_mouse_to_cell(to_cell, true)
	await __await_token_id_at_cell(IDs.TREEE,to_cell)
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.BUSHH],
			[IDs.EMPTY,IDs.TREEE,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY]
		]
	)

	var expected_points = 0
	expected_points += (points_per_id[IDs.GRASS] * 3)
	expected_points += (points_per_id[IDs.BUSHH] * 3)
	
	assert_int(game_manager.points).is_equal(expected_points)

func test__action_should_not_move_enemies() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	__paralized_enemies(true)
	
	var enemy_cell = Vector2(0,1)
	
	## enemy cell the token
	await __async_move_mouse_to_cell(enemy_cell, false)
	await __await_assert_invalid_cell_conditions(enemy_cell)
	await __async_move_mouse_to_cell(enemy_cell, true)
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.floating_token).is_not_null()

	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.MNKEL,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	assert_int(game_manager.points).is_equal(0)

func test__action_move_should_not_work_on_chests() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.CHE_B,IDs.EMPTY],
		[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.LV_UP)
	
	var chest_cell = Vector2(1,1)
	var ID__PRIZE := __get_chest_prize_id_at_cell(chest_cell)
	
	await __async_move_mouse_to_cell(chest_cell, false)
	await __await_assert_invalid_cell_conditions(chest_cell)
	await __async_move_mouse_to_cell(chest_cell, true)
	await __await_assert_floating_token_is_boxed()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,ID__PRIZE,IDs.EMPTY],
			[IDs.EMPTY,IDs.GRASS,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)

func test__action_move_should_not_move_prizes() -> void:
	
	var landscape := [
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.PR_CA,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, IDs.MOVEE)
	__paralized_enemies(true)
	
	var prize_cell = Vector2(2,1)
	
	## prize cell the token should be connsumed
	await __async_move_mouse_to_cell(prize_cell, false)
	await __await_assert_invalid_cell_conditions(prize_cell)
	await __async_move_mouse_to_cell(prize_cell, true)
	await __await_assert_floating_token_is_boxed()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
