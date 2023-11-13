# GdUnit generated TestSuite
class_name GameManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/game/gameplay.tscn'
var __all_token_data: AllTokensData

var runner : GdUnitSceneRunner
var game_manager: GameManager
var state_machine: StateMachine
var board: Board

func __get_cell_center_position(cell:Vector2, board:Board) -> Vector2:
	return board.position + Vector2(cell.x * Constants.CELL_SIZE.x, cell.y * Constants.CELL_SIZE.y) + Constants.CELL_SIZE/2 

func __set_to_player_turn_with_empty_board(runner:GdUnitSceneRunner) -> void:
	
	# sadly this does not seems to work
	# runner.await_func_on(state_machine, "get_current_state").wait_until(5000).is_equal(Constants.PlayingState.PLAYER)
	while (game_manager.get_floating_token() == null):
		await await_idle_frame()
		
	board.configure()
	
	assert_object(game_manager.get_floating_token()).is_not_null()
	game_manager.discard_floating_token()
	
func __set_floating_token(runner:GdUnitSceneRunner, token_id:String) -> BoardToken:
	
	__all_token_data = auto_free(AllTokensData.new())
	var token_data := __all_token_data.get_token_data_by_id(token_id)
	var game_manager:GameManager = runner.find_child("GameManager") as GameManager
	
	var floating_token := game_manager.create_floating_token(token_data)
	assert_object(floating_token).is_not_null()
	return floating_token

func __click_on_cell(runner:GdUnitSceneRunner, cell:Vector2, board:Board) -> void:
	runner.simulate_mouse_move(__get_cell_center_position(cell, board)) 
	await await_idle_frame()
	board.get_cell_at_position(cell).__just_for_test_click_cell()
	await await_idle_frame()

func before_test():
	runner = scene_runner(__source)
	game_manager = runner.find_child("GameManager") as GameManager
	assert_object(game_manager).is_not_null()
	state_machine = runner.find_child("StateMachine") as StateMachine
	assert_object(state_machine).is_not_null()
	board = runner.find_child("Board") as Board
	assert_object(board).is_not_null()
	
	
func after_test():
	runner = null
	game_manager.queue_free()
	game_manager = null
	state_machine.queue_free()
	state_machine = null
	board.queue_redraw()
	board = null
	

func test__move_over_cells() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	__set_floating_token(runner, "0_grass")

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
	await __set_to_player_turn_with_empty_board(runner)
	
	__set_floating_token(runner, "0_grass")
	
	var test_cell = Vector2(1,2)

	var cell := board.get_cell_at_position(test_cell)
	assert_bool(board.is_cell_empty(test_cell)).is_true()
	
	await __click_on_cell(runner, test_cell, board)
	
	runner.await_func_on(board, "is_cell_empty", [test_cell]).wait_until(2000).is_false()
	
	var token := board.get_token_at_cell(test_cell)
	assert_object(token).is_not_null()
	assert_str(token.id).is_equal("0_grass")
	
