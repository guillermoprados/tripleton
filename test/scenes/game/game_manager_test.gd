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

var ID_EMPTY = ''
var ID_GRASS = '0_grass'
var ID_BUSHH = '1_bush'
var ID_TREEE = '2_tree'
var ID_MNKEL = 'monokelo'
var ID_GRAVE = 'grave'
var ID_CHE_B = 'chest_bronze'

func enum_is_equal(current:Variant, expected:Variant) -> bool:
	return current == expected
	
func enum_is_not_equal(current:Variant, expected:Variant) -> bool:
	return current != expected

func __set_to_player_turn_with_empty_board(landscape:Array, initial_token_id:String = ID_EMPTY) -> void:
	
	await __async_await_for_enum(state_machine, "current_state", Constants.PlayingState.LOADING, enum_is_equal, 2)
	var load_state = state_machine.active_state
	assert_that(load_state.id).is_equal(Constants.PlayingState.LOADING)
	await runner.await_func_on(load_state, "is_landscape_created").wait_until(1000).is_true()
	board.configure(landscape.size(), landscape[0].size())
	
	if initial_token_id == ID_EMPTY:
		await __wait_to_next_player_turn()
	else:
		await __wait_to_next_player_turn_with_floating_token(initial_token_id)
		
	__prepare_landscape(landscape, runner)
	

func __wait_to_next_player_turn() -> void:
	await await_idle_frame()
	await __async_await_for_enum(state_machine, "current_state", Constants.PlayingState.PLAYER, enum_is_equal, 2)
	await await_idle_frame()
	await runner.await_func_on(game_manager, "get_floating_token").wait_until(200).is_not_null()
	
func __wait_to_next_player_turn_with_floating_token(token_id:String) -> void:
	
	await __wait_to_next_player_turn()
	
	game_manager.discard_floating_token()
	
	var token_data := __all_token_data.get_token_data_by_id(token_id)
	game_manager.create_floating_token(token_data)
	assert_object(game_manager.floating_token).is_not_null()
	
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
	
func __async_await_for_enum(obj:Object, prop_name:String, value:Variant, comparison:Callable, time:float) -> bool:
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
	
func __prepare_landscape(landscape:Array, runner:GdUnitSceneRunner) -> void:
	var rows = landscape.size()
	var columns = landscape[0].size()
	for row in range(rows):
		for col in range(columns):
			var id = landscape[row][col]
			if id != ID_EMPTY:
				var token_data:TokenData = __all_token_data.get_token_data_by_id(id)
				var token = game_manager.instantiate_new_token(token_data, Constants.TokenStatus.PLACED)
				board.set_token_at_cell(token, Vector2(row, col))
 
func __paralized_enemies(paralized:bool) -> void:
	for token in board.get_tokens_of_type(Constants.TokenType.ENEMY):
		var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
		for key in enemies:
			enemies[key].behavior.paralize = paralized
