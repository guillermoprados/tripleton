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
	await __async_await_for_enum(cell, "highlight", Constants.CellHighlight.VALID, enum_is_equal, 2)
	assert_that(game_manager.get_floating_token().highlight).is_equal(Constants.TokenHighlight.VALID)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.VALID)
	var expected_moves :Array[Vector2] = [] 
	for move in moves:
		expected_moves.append(cell_index + move)
	
	var token:= game_manager.floating_token
	var action : ActionMove = token.action as ActionMove
	var affected_cells := action.affected_cells(cell_index, board.cell_tokens_ids)
	assert_array(affected_cells).contains_exactly_in_any_order(expected_moves)

func test__move_cell_valid_moves_on_different_positions() -> void:
	
	var landscape := [
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_GRASS,ID_GRASS,ID_EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MOVEE)
	
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
		[ID_GRASS,ID_EMPTY,ID_GRASS],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_GRASS,ID_GRASS,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MOVEE)
	
	var test_cell := Vector2(0,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_wasted_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_false()
	assert_object(game_manager.get_floating_token()).is_null()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_ROCKK,ID_GRASS],
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_GRASS,ID_GRASS,ID_GRASS],
		]
	)
	
func test__move_action_invalid() -> void:
	
	var landscape := [
		[ID_GRASS,ID_GRASS,ID_GRASS],
		[ID_EMPTY,ID_GRASS,ID_EMPTY],
		[ID_GRASS,ID_GRASS,ID_GRASS],
	]
	
	await __set_to_player_state_with_board(landscape, ID_MOVEE)
	
	var test_cell := Vector2(0,1)
	await __async_move_mouse_to_cell(test_cell, false)
	await __await_assert_invalid_cell_conditions(test_cell)
	await __async_move_mouse_to_cell(test_cell, true)
	
	assert_bool(board.enabled_interaction).is_true()
	assert_object(game_manager.get_floating_token()).is_not_null()

	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[ID_GRASS,ID_GRASS,ID_GRASS],
			[ID_EMPTY,ID_GRASS,ID_EMPTY],
			[ID_GRASS,ID_GRASS,ID_GRASS],
		]
	)
