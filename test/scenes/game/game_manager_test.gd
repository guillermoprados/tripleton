# GdUnit generated TestSuite
class_name GameManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/game/gameplay.tscn'

func __get_cell_center_position(cell:Vector2, board:Board) -> Vector2:
	return board.position + Vector2(cell.x * Constants.CELL_SIZE.x, cell.y * Constants.CELL_SIZE.y) + Constants.CELL_SIZE/2 

func __get_clear_board_on_player_turn(runner:GdUnitSceneRunner) -> Board:
	
	var state_machine:Node = runner.find_child("StateMachine")
	
	assert_object(state_machine).is_not_null()
	
	runner.await_func_on(state_machine, "get_current_state").wait_until(100).is_equal(Constants.PlayingState.PLAYER)

	var board := runner.find_child("Board") as Board
	
	assert_object(board).is_not_null()
	
	board.configure()
	
	return board


func test__move_over_cells() -> void:
	var runner := scene_runner(__source)
	var board := __get_clear_board_on_player_turn(runner)
	
	var test_cell_in = Vector2(1,2)
	var test_cell_out = Vector2(2,3)
	
	var cell := board.get_cell_at_position(test_cell_in)
	runner.await_func_on(cell, "get_highlight").wait_until(100).is_equal(Constants.CellHighlight.NONE)
	
	runner.simulate_mouse_move(__get_cell_center_position(test_cell_in, board)) 
	await await_idle_frame()
	runner.await_func_on(cell, "get_highlight").wait_until(100).is_equal(Constants.CellHighlight.VALID)
	
	runner.simulate_mouse_move(__get_cell_center_position(test_cell_out, board)) 
	await await_idle_frame()
	runner.await_func_on(cell, "get_highlight").wait_until(1000).is_equal(Constants.CellHighlight.NONE)
	
	
func test__place_single_token() -> void:
	var runner := scene_runner(__source)
	
	var board := __get_clear_board_on_player_turn(runner)

	assert_object(board).is_not_null()
