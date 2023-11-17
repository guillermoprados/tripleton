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
var spawn_token_cell: BoardCell

const IDs = {
	EMPTY = '',
	GRASS = '0_grass',
	BUSHH = '1_bush',
	TREEE = '2_tree',
	B_TRE = '3_big_tree',
	MNKEL = 'monokelo',
	GRAVE = 'grave',
	CHE_B = 'chest_bronze',
	CHE_S = 'chest_silver',
	LAMPP = '0_lamp',
	BOMBB = 'bomb',
	LV_UP = 'level_up',
	MOVEE = 'move',
	WILDC = 'wildcard',
	ROCKK = 'rock',
	PR_CA = 'cat_white'
}



var points_per_id : Dictionary = {}

func before():
	__all_token_data = auto_free(AllTokensData.new())
	__all_token_data.__load_tokens_data(IDs.values())
	var keys = IDs.keys()
	for key in keys:
		var token_id = IDs[key]
		if token_id == IDs.EMPTY:
			continue
		var data = __all_token_data.get_token_data_by_id(token_id)
		if data is TokenPrizeData:
			points_per_id[token_id] = data.reward_value

func before_test():
	runner = scene_runner(__source)
	game_manager = runner.find_child("GameManager") as GameManager
	assert_object(game_manager).is_not_null()
	state_machine = runner.find_child("StateMachine") as StateMachine
	assert_object(state_machine).is_not_null()
	board = runner.find_child("Board") as Board
	assert_object(board).is_not_null()
	spawn_token_cell = runner.find_child("SpawnTokenCell") as BoardCell
	assert_object(spawn_token_cell).is_not_null()
	
func after_test():
	runner = null
	game_manager.queue_free()
	game_manager = null
	state_machine.queue_free()
	state_machine = null
	board.queue_redraw()
	board = null
	
func property_is_equal(current:Variant, expected:Variant) -> bool:
	return current == expected
	
func property_is_not_equal(current:Variant, expected:Variant) -> bool:
	return current != expected

func __set_to_player_state_with_board(landscape:Array, initial_token_id:String = IDs.EMPTY) -> void:
	
	await __async_await_for_property(state_machine, "current_state", Constants.PlayingState.LOADING, property_is_equal, 2)
	var load_state = state_machine.active_state
	assert_that(load_state.id).is_equal(Constants.PlayingState.LOADING)
	await runner.await_func_on(load_state, "is_landscape_created").wait_until(1000).is_true()
	board.configure(landscape.size(), landscape[0].size())
	
	await __wait_to_next_player_turn(initial_token_id)
		
	__prepare_landscape(landscape, runner)
	
func __wait_to_game_state(state:Constants.PlayingState) -> void:
	await await_idle_frame()
	await __async_await_for_property(state_machine, "current_state", state, property_is_equal, 2)
	
func __wait_to_next_player_turn(token_id:String = IDs.EMPTY) -> void:
	
	await __wait_to_game_state(Constants.PlayingState.PLAYER)
	
	await await_idle_frame()
	await runner.await_func_on(game_manager, "get_floating_token").wait_until(200).is_not_null()
	
	if token_id != IDs.EMPTY:
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
	
	await await_idle_frame()
	
func __async_await_for_property(obj:Object, prop_name:String, value:Variant, comparison:Callable, time:float) -> bool:
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
		
func __prepare_landscape(landscape:Array, runner:GdUnitSceneRunner) -> void:
	var rows = landscape.size()
	var columns = landscape[0].size()
	for row in range(rows):
		for col in range(columns):
			var id = landscape[row][col]
			if id != IDs.EMPTY:
				var token_data:TokenData = __all_token_data.get_token_data_by_id(id)
				var token = game_manager.instantiate_new_token(token_data, Constants.TokenStatus.PLACED)
				board.set_token_at_cell(token, Vector2(row, col))
 
func __paralized_enemies(paralized:bool) -> void:
	for token in board.get_tokens_of_type(Constants.TokenType.ENEMY):
		var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
		for key in enemies:
			enemies[key].behavior.paralize = paralized

func __await_assert_floating_token_is_boxed() -> void:
	assert_object(game_manager.floating_token).is_not_null()
	assert_bool(board.enabled_interaction).is_true()
	await __async_await_for_property(game_manager.floating_token, "position", spawn_token_cell.position, property_is_equal, 2)
	assert_that(game_manager.floating_token.position).is_equal(spawn_token_cell.position)
	#I really don't know why this fails:
	#assert_that(game_manager.floating_token.current_status).is_equal(Constants.TokenStatus.BOXED)
	
	
func __await_assert_empty_cell_conditions(cell_index:Vector2) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.NONE, property_is_equal, 2)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)
	
func __await_assert_valid_cell_conditions(cell_index:Vector2, cell_highlight:Constants.CellHighlight = Constants.CellHighlight.VALID ) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", cell_highlight, property_is_equal, 2)
	if game_manager.floating_token.type == Constants.TokenType.ACTION:
		assert_that(game_manager.get_floating_token().highlight).is_equal(Constants.TokenHighlight.VALID)
	else:
		assert_that(game_manager.get_floating_token().highlight).is_equal(Constants.TokenHighlight.NONE)
	assert_that(cell.highlight).is_equal(cell_highlight)
	
func __await_assert_invalid_cell_conditions(cell_index:Vector2) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.INVALID, property_is_equal, 2)
	assert_that(game_manager.get_floating_token().highlight).is_equal(Constants.TokenHighlight.INVALID)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.INVALID)

func __await_assert_wasted_cell_conditions(cell_index:Vector2) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.WASTED, property_is_equal, 2)
	assert_that(game_manager.get_floating_token().highlight).is_equal(Constants.TokenHighlight.WASTED)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.WASTED)

func __await_token_id_at_cell(token_id: String, at_cell:Vector2) -> void:
	await runner.await_func_on(board, "cell_tokens_id_at",[at_cell.x,at_cell.y]).wait_until(1000).is_equal(token_id)
	assert_that(board.cell_tokens_ids[at_cell.x][at_cell.y]).is_equal(token_id)

func __get_chest_ID__PRIZE_at_cell(cell_index:Vector2) -> String:
	var chest_data: TokenChestData = board.get_token_at_cell(cell_index).data
	var ID__PRIZE := chest_data.get_random_prize().id
	return ID__PRIZE
