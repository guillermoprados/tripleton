# GdUnit generated TestSuite
class_name GameManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
var __game_config_data: GameConfigData
const __source = 'res://scenes/game/gameplay.tscn'
var __test_config_file := "res://generated/game_config.json"

var runner : GdUnitSceneRunner
var game_manager: GameManager
var state_machine: StateMachine
var board: Board
var initial_token_slot: InitialTokenSlot

var __diff_easy_res := "res://data/difficulties/diff_0_easy.tres"
var __diff_medium_res := "res://data/difficulties/diff_1_medium.tres"
var __diff_hard_res := "res://data/difficulties/diff_2_hard.tres"
	
const IDs = {
	EMPTY = '',
	BOMBB = 'bomb',
	LV_UP = 'level_up',
	MOVEE = 'move',
	WILDC = 'wildcard',
	REMOV = 'remove_all',
	CHE_B = '0_chest_bronze',
	CHE_S = '1_chest_silver',
	CHE_G = '2_chest_gold',
	CHE_D = '4_chest_diamond',
	GRASS = '0_grass',
	BUSHH = '1_bush',
	TREEE = '2_tree',
	B_TRE = '3_big_tree',
	GRAVE = '0_grave',
	TOMBB = '1_tomb',
	SRINE = '2_shrine',
	LAMPP = '0_lamp',
	GATEE = '1_gate',
	HOUSE = '2_house',
	COTEG = '3_cottage',
	TOWER = '4_tower',
	PALAC = '5_palace',
	FORTR = '6_fortress',
	STONE = '0_stone',
	ROCKK = '1_rock',
	STA_B = '2_statue',
	STA_G = '3_gold_statue',
	MOLEE = 'mole',
	MNKEL = 'monokelo',
	PR_CA = 'cat_white'
}



var points_per_id : Dictionary = {}

func before() -> void:
	__game_config_data = auto_free(GameConfigData.new())
	__game_config_data.json_config_file = __test_config_file
	__game_config_data.__load_tokens_data(IDs.values())
	var keys := IDs.keys()
	for key:String in keys:
		var token_id : String = IDs[key]
		if token_id == IDs.EMPTY:
			continue
		var data := __game_config_data.get_token_data_by_id(token_id)
		if data is TokenPrizeData:
			points_per_id[token_id] = data.reward_value

func before_test() -> void:
	runner = scene_runner(__source)
	game_manager = runner.find_child("GameManager") as GameManager
	assert_object(game_manager).is_not_null()
	state_machine = runner.find_child("StateMachine") as StateMachine
	assert_object(state_machine).is_not_null()
	board = runner.find_child("Board") as Board
	assert_object(board).is_not_null()
	initial_token_slot = runner.find_child("InitialTokenSlot") as InitialTokenSlot
	assert_object(initial_token_slot).is_not_null()
	
func after_test() -> void:
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

func __set_to_player_state(initial_token_id:String = IDs.EMPTY) -> void:
		var landscape := [
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
		await __set_to_player_state_with_board(landscape, initial_token_id)
		
func __set_to_player_state_with_board(landscape:Array, initial_token_id:String = IDs.EMPTY) -> void:
	
	await __async_await_for_property(state_machine, "current_state", Constants.PlayingState.LOADING, property_is_equal, 2)
	var load_state := state_machine.active_state
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
	await __async_await_for_property(game_manager.initial_token_slot, "token", null, property_is_not_equal, 2)
	
	if token_id and token_id != IDs.EMPTY:
		var token_data := __game_config_data.get_token_data_by_id(token_id)
		game_manager.initial_token_slot.discard_token()
		game_manager.initial_token_slot.spawn_token(token_data.id)
		game_manager.initial_token_slot.focus_token()

func __async_move_mouse_to_cell(cell_index:Vector2, click:bool) -> void:
	await __async_move_mouse_to_cell_object(board.get_cell_at_position(cell_index), click)
	
func __async_move_mouse_to_cell_object(cell:BoardCell, click:bool) -> void:
	
	# move outside the board
	runner.simulate_mouse_move(Vector2.ZERO) 
	await await_idle_frame()
	
	while runner.get_mouse_position() != Vector2.ZERO:
		await await_idle_frame()
	
	var cell_pos := cell.global_position
	
	runner.simulate_mouse_move(cell_pos) 
	await await_idle_frame()
	
	while runner.get_mouse_position() != cell_pos:
		await await_idle_frame()
	
	if click:
		await await_idle_frame()
		cell.__just_for_test_click_cell()
	
	await await_idle_frame()

func __async_await_for_property(obj:Object, prop_name:String, value:Variant, comparison:Callable, time:float) -> bool:
	var init_time := Time.get_unix_time_from_system()
	while (Time.get_unix_time_from_system() - init_time < time):
		var current_value :Variant = obj.get(prop_name)
		if comparison.call(current_value, value):
			return true
		await await_idle_frame()
	assert(false, "property " +prop_name+" never reached the required condition")
	return false
	
func __ascync_await_for_time_helper(time:float) -> void:
	var init_time := Time.get_unix_time_from_system()
	while (Time.get_unix_time_from_system() - init_time < time):
		await await_idle_frame()
		
func __prepare_landscape(landscape:Array, runner:GdUnitSceneRunner) -> void:
	var rows :int = landscape.size()
	var columns :int = landscape[0].size()
	for row in range(rows):
		for col in range(columns):
			var id :String = landscape[row][col]
			if id != IDs.EMPTY:
				var token_data:TokenData = __game_config_data.get_token_data_by_id(id)
				var token := game_manager.instantiate_new_token(token_data.id, Constants.TokenStatus.PLACED)
				board.set_token_at_cell(token, Vector2(row, col))
 
func __paralized_enemies(paralized:bool) -> void:
	var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key:Vector2 in enemies:
		enemies[key].behavior.paralize = paralized

func __await_assert_floating_token_is_boxed() -> void:
	
	if game_manager.floating_token:
		await __async_await_for_property(game_manager, "floating_token", null, property_is_equal, 2)
		assert_object(game_manager.floating_token).is_null()
	
	if not game_manager.initial_token_slot.token:
		await __async_await_for_property(game_manager.initial_token_slot, "token", null, property_is_not_equal, 2)
	
	assert_object(game_manager.initial_token_slot.token).is_not_null()
	assert_bool(board.enabled_interaction).is_true()
	await __async_await_for_property(game_manager.initial_token_slot.token, "position", Vector2.ZERO, property_is_equal, 2)
	
func __await_assert_empty_cell_conditions(cell_index:Vector2) -> void:
	await __await_assert_empty_cell_object_conditions(board.get_cell_at_position(cell_index))

func __await_assert_empty_cell_object_conditions(cell:BoardCell) -> void:
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.NONE, property_is_equal, 2)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.NONE)

func __await_assert_actionable_conditions(cell_index:Vector2) -> void:
	var cell := board.get_cell_at_position(cell_index)
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.COMBINATION, property_is_equal, 2)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.COMBINATION)

func __await_assert_valid_cell_conditions(cell_index:Vector2, cell_highlight:Constants.CellHighlight = Constants.CellHighlight.VALID ) -> void:
	var cell:BoardCell = board.get_cell_at_position(cell_index) 
	await __await_assert_valid_cell_object_conditions(cell, cell_highlight)

func __await_assert_valid_cell_object_conditions(cell:BoardCell, cell_highlight:Constants.CellHighlight = Constants.CellHighlight.VALID ) -> void:
	await __async_await_for_property(cell, "highlight", cell_highlight, property_is_equal, 2)
	if game_manager.floating_token.type == Constants.TokenType.ACTION:
		assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.VALID)
	else:
		assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.FOCUSED)
	assert_that(cell.highlight).is_equal(cell_highlight)
	
func __await_assert_invalid_cell_conditions(cell_index:Vector2) -> void:
	await __await_assert_invalid_cell_object_conditions(board.get_cell_at_position(cell_index))

func __await_assert_invalid_cell_object_conditions(cell:BoardCell) -> void:
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.INVALID, property_is_equal, 2)
	assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.INVALID)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.INVALID)

func __await_assert_wasted_cell_conditions(cell_index:Vector2) -> void:
	await __await_assert_wasted_cell_object_conditions(board.get_cell_at_position(cell_index))
	
func __await_assert_wasted_cell_object_conditions(cell:BoardCell) -> void:
	await __async_await_for_property(cell, "highlight", Constants.CellHighlight.WASTED, property_is_equal, 2)
	assert_that(game_manager.floating_token.highlight).is_equal(Constants.TokenHighlight.WASTED)
	assert_that(cell.highlight).is_equal(Constants.CellHighlight.WASTED)

func __await_token_id_at_cell(token_id: String, at_cell:Vector2) -> void:
	await runner.await_func_on(board, "cell_tokens_id_at",[at_cell.x,at_cell.y]).wait_until(1000).is_equal(token_id)
	assert_that(board.cell_tokens_ids[at_cell.x][at_cell.y]).is_equal(token_id)

func __get_chest_prize_id_at_cell(cell_index:Vector2) -> String:
	var chest_data: TokenChestData = board.get_token_at_cell(cell_index).data
	var prize_id := chest_data.get_random_prize_id()
	return prize_id

func __set_to_last_difficulty()->void:
	game_manager.__difficulty_index = game_manager.__difficulties.size() - 1
	assert_that(game_manager.difficulty.level).is_equal(Constants.DifficultyLevel.LEGENDARY)

func __await_combination_to_combination(id_from:String, id_to:String, difficulty:Constants.DifficultyLevel = Constants.DifficultyLevel.EASY) -> void:
	
	var IDs_FROM_ := id_from
	var IDs__TO__ := id_to
	
	var landscape := [
		[IDs_FROM_,IDs_FROM_,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
	]
	
	await __set_to_player_state_with_board(landscape)
	
	var is_from_chest : bool = (IDs_FROM_ == IDs.CHE_B) or (IDs_FROM_ == IDs.CHE_S) or (IDs_FROM_ == IDs.CHE_G) or (IDs_FROM_ == IDs.CHE_D)
	var is_to_chest : bool = (IDs__TO__ == IDs.CHE_B) or (IDs__TO__ == IDs.CHE_S) or (IDs__TO__ == IDs.CHE_G) or (IDs__TO__ == IDs.CHE_D)

	while game_manager.difficulty.level < difficulty:
		game_manager.__next_difficulty()
	
	## third token
	await __wait_to_next_player_turn(IDs_FROM_)
	
	var third_cell := Vector2(0,2)
	await __async_move_mouse_to_cell(third_cell, true)

	## check
	await __wait_to_next_player_turn()
	
	assert_array(board.cell_tokens_ids).contains_same_exactly(
		[
			[IDs.EMPTY,IDs.EMPTY,IDs__TO__],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
			[IDs.EMPTY,IDs.EMPTY,IDs.EMPTY],
		]
	)
	
	if is_from_chest and is_to_chest:
		#assert_int(game_manager.game_points).is_zero()
		pass # i need to check what I'll do with it
	else:
		assert_int(game_manager.game_points).is_not_zero()
	
	assert_int(game_manager.game_points).is_equal(points_per_id[IDs_FROM_] * 3)
