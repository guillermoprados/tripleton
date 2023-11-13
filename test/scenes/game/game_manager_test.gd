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
	

func test__move_over_cells() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	__set_floating_token(runner, "0_grass")

	var test_cell_in = Vector2(0,3)
	var test_cell_out = Vector2(2,3)
	
	var cell := board.get_cell_at_position(test_cell_in)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)
	
	await __async_move_mouse_to_cell(test_cell_in, false)
	
	await __ascync_await_for_enum(cell, "highlight", Constants.CellHighlight.VALID, enum_is_equal, 5)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.VALID)
	
	await __async_move_mouse_to_cell(test_cell_out, false)
	await __ascync_await_for_enum(cell, "highlight", Constants.CellHighlight.NONE, enum_is_equal, 5)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)
	
	
func test__place_single_token() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	__set_floating_token(runner, "0_grass")
	
	var test_cell = Vector2(1,2)

	var cell := board.get_cell_at_position(test_cell)
	assert_bool(board.is_cell_empty(test_cell)).is_true()
	
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	assert_object(game_manager.get_floating_token()).is_null()
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(test_cell)).is_false()
	
	var token := board.get_token_at_cell(test_cell)
	assert_object(token).is_not_null()
	assert_str(token.id).is_equal("0_grass")
	
	assert_int(game_manager.points).is_equal(0)
	
func test__try_to_place_token_in_occupied_slot() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	var test_cell = Vector2(1,2)
	
	## first token
	__set_floating_token(runner, "0_grass")
	await __async_move_mouse_to_cell(test_cell, true)
	
	## second token (BUSH)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, "1_bush")
	await __async_move_mouse_to_cell(test_cell, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var token := board.get_token_at_cell(test_cell)
	assert_str(token.id).is_equal("0_grass")
	assert_int(game_manager.points).is_equal(0)
	
func test__try_single_level_combination() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id("0_grass").reward_value
	
	## first token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, "0_grass")
	var first_cell = Vector2(0,0)
	await __async_move_mouse_to_cell(first_cell, true)
	
	## second token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, "0_grass")
	var second_cell = Vector2(0,1)
	await __async_move_mouse_to_cell(second_cell, true)
	
	## third token
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, "0_grass")
	var third_cell = Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(first_cell)).is_true()
	assert_bool(board.is_cell_empty(second_cell)).is_true()
	assert_bool(board.is_cell_empty(third_cell)).is_false()
	
	var token = board.get_token_at_cell(third_cell)
	assert_str(token.id).is_equal("1_bush")
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(grass_points * 3)

func test__try_multi_level_combination() -> void:
	
	await __set_to_player_turn_with_empty_board(runner)
	
	var grass_points : int = __all_token_data.get_token_data_by_id("0_grass").reward_value
	var bush_points : int = __all_token_data.get_token_data_by_id("1_bush").reward_value
	
	## grass level
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_1 = Vector2(0,0)
	__set_floating_token(runner, "0_grass")
	await __async_move_mouse_to_cell(cell_1, true)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_2 = Vector2(0,1)
	__set_floating_token(runner, "0_grass")
	await __async_move_mouse_to_cell(cell_2, true)
	
	## bush level
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_3 = Vector2(1,0)
	__set_floating_token(runner, "1_bush")
	await __async_move_mouse_to_cell(cell_3, true)
	
	await __wait_to_next_player_turn_removing_floating_token(runner)
	var cell_4 = Vector2(2,0)
	__set_floating_token(runner, "1_bush")
	await __async_move_mouse_to_cell(cell_4, true)
	
	## add grass
	var cell_5 := Vector2(1,1)
	await __wait_to_next_player_turn_removing_floating_token(runner)
	__set_floating_token(runner, "0_grass")
	await __async_move_mouse_to_cell(cell_5, true)
	
	## check
	await __wait_to_next_player_turn_removing_floating_token(runner)
	assert_bool(board.is_cell_empty(cell_1)).is_true()
	assert_bool(board.is_cell_empty(cell_2)).is_true()
	assert_bool(board.is_cell_empty(cell_3)).is_true()
	assert_bool(board.is_cell_empty(cell_4)).is_true()
	assert_bool(board.is_cell_empty(cell_5)).is_false()

	var token = board.get_token_at_cell(cell_5)
	assert_str(token.id).is_equal("2_tree")
	
	var expected_points = (grass_points * 3) + (bush_points * 3)
	assert_int(game_manager.points).is_not_zero()
	assert_int(game_manager.points).is_equal(expected_points)
