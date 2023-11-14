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

var ID_GRASS = '0_grass'
var ID_BUSH = '1_bush'
var ID_TREE = '2_tree'
var ID_MONOKELO = 'monokelo'

func enum_is_equal(current:Variant, expected:Variant) -> bool:
	return current == expected
	
func enum_is_not_equal(current:Variant, expected:Variant) -> bool:
	return current != expected

func __set_to_player_turn_with_empty_board(runner:GdUnitSceneRunner) -> void:
	await __wait_to_next_player_turn_removing_floating_token(runner)
	board.configure()
	
func __wait_to_next_player_turn_removing_floating_token(runner:GdUnitSceneRunner):
	await await_idle_frame()
	await __ascync_await_for_enum(state_machine, "current_state", Constants.PlayingState.PLAYER, enum_is_equal, 2)
	await await_idle_frame()
	assert_object(game_manager.get_floating_token()).is_not_null()
	game_manager.discard_floating_token()
	
func __set_floating_token(runner:GdUnitSceneRunner, token_id:String) -> BoardToken:
	var token_data := __all_token_data.get_token_data_by_id(token_id)
	var game_manager:GameManager = runner.find_child("GameManager") as GameManager
	
	var floating_token := game_manager.create_floating_token(token_data)
	assert_object(floating_token).is_not_null()
	return floating_token

func __async_move_mouse_to_cell(cell_index:Vector2, click:bool) -> void:
	
	runner.simulate_mouse_move(board.position) 
	await await_idle_frame()
	
	while runner.get_mouse_position() != board.position:
		await await_idle_frame()
	
	var cell_pos = board.position + Vector2(cell_index.y * Constants.CELL_SIZE.x, cell_index.x * Constants.CELL_SIZE.y) + Constants.CELL_SIZE/2 
	
	runner.simulate_mouse_move(cell_pos) 
	await await_idle_frame()
	
	while runner.get_mouse_position() != cell_pos:
		await await_idle_frame()
	
	if click:
		var cell := board.get_cell_at_position(cell_index)
		cell.__just_for_test_click_cell()
		await await_idle_frame()
	
func __ascync_await_for_enum(obj:Object, prop_name:String, value:Variant, comparison:Callable, time:float) -> bool:
	var init_time := Time.get_unix_time_from_system()
	while (Time.get_unix_time_from_system() - init_time < time):
		var current_value = obj.get(prop_name)
		if comparison.call(current_value, value):
			return true
		await await_idle_frame()
	return false
	
func __ascync_await_for_time_helper(time:float) -> void:
	var init_time := Time.get_unix_time_from_system()
	while (Time.get_unix_time_from_system() - init_time < time):
		await await_idle_frame()
	
func before_test():
	runner = scene_runner(__source)
	game_manager = runner.find_child("GameManager") as GameManager
	assert_object(game_manager).is_not_null()
	state_machine = runner.find_child("StateMachine") as StateMachine
	assert_object(state_machine).is_not_null()
	board = runner.find_child("Board") as Board
	assert_object(board).is_not_null()
	__all_token_data = auto_free(AllTokensData.new())
	
func after_test():
	runner = null
	game_manager.queue_free()
	game_manager = null
	state_machine.queue_free()
	state_machine = null
	board.queue_redraw()
	board = null
