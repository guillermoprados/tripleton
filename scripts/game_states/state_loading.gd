extends StateBase

class_name StateLoading

@export_category("Required Data Configuration")
@export var landscape_tokens:Array[TokenData]

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.LOADING

var __inner_state := 0
const STATE_PREPARE := 0
const STATE_PREPARE_UI := 1
const STATE_CONFIG := 2
const STATE_SET_OBJECTS := 3
const STATE_PREPARE_LANDSCAPE := 4
const STATE_READY := 5

func _on_state_entered() -> void:
	__inner_state = STATE_PREPARE
	
# override in states
func _on_state_exited() -> void:
	game_manager.gameplay_ui.fade_to_transparent()

func _process(delta:float) -> void:
	match(__inner_state):
		STATE_PREPARE:
			pass
		STATE_CONFIG:
			#assert(ordered_difficulties.size() > 0, "Add difficulties")
			#game_manager.__set_difficulties(ordered_difficulties)
			load_difficulties()
			pass
		STATE_SET_OBJECTS:
			__position_game_objects()
		STATE_PREPARE_LANDSCAPE:
			__create_landscape()
		STATE_PREPARE_UI:
			game_manager.connect_ui()
			game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
		STATE_READY:
			state_finished.emit(id)
	
	__inner_state += 1
	
func __position_game_objects() -> void:
	game_manager.__adjust_board_position()
	game_manager.__adjust_initial_slot_position()
	game_manager.__adjust_save_token_slots_positions()
	
func __create_landscape() -> void:
	randomize()
	#TODO: DO NOT PLACE ENEMIES IN ENCLOSED PLACES!!
	var rand_num := __get_random_between(Constants.MIN_LANDSCAPE_TOKENS, Constants.MAX_LANDSCAPE_TOKENS)
	for i in range(rand_num + 1):  # +1 to make it inclusive of the random number
		var random_cell:Vector2 = __get_random_position(board.rows, board.columns)
		if board.is_cell_empty(random_cell):
			var rand_token := __get_random_between(0, landscape_tokens.size() - 1)
			var random_token_id:String = landscape_tokens[rand_token].id
			var random_token := game_manager.instantiate_new_token(random_token_id, Constants.TokenStatus.PLACED)
			board.set_token_at_cell(random_token, random_cell)

func __get_random_between(min_val: int, max_val: int) -> int:
	return min_val + randi() % (max_val - min_val + 1)

func __get_random_position(rows: int, columns: int) -> Vector2:
	var rand_row := randi() % rows
	var rand_col := randi() % columns
	return Vector2(rand_row, rand_col)

func is_landscape_created() -> bool:
	return __inner_state > STATE_PREPARE_LANDSCAPE

func load_difficulties() -> void:
	
	var difficulties_ids: Array = [
		Constants.DifficultyLevel.EASY,
		Constants.DifficultyLevel.MEDIUM,
		Constants.DifficultyLevel.HARD,
		Constants.DifficultyLevel.SUPREME,
		Constants.DifficultyLevel.LEGENDARY,
	]
	
	var difficulties:Array[Difficulty] = []
	
	for id:Constants.DifficultyLevel in difficulties_ids:
		
		var difficulty_data:Dictionary = game_manager.game_config_data.get_difficulties_config_data(id)
		
		var difficulty := Difficulty.new()
		
		difficulty.level = id
		difficulty.__total_points = difficulty_data['total_points']
		difficulty.__save_token_slots = difficulty_data['save_token_slots']
		difficulty.__max_level_token = difficulty_data['max_level_token']
		difficulty.__max_level_chest_id = difficulty_data['max_level_chest_id']
		
		var difficulty_id_as_string := Difficulty.as_string(id)
		var token_probs_by_set:Dictionary = game_manager.game_config_data.get_spawn_probabilities_set_data(difficulty_id_as_string)
		
		for token_id:String in token_probs_by_set.keys():
			match token_probs_by_set[token_id]:
				"0_common":
					difficulty.__common_token_ids.append(token_id)
				"1_frequent":
					difficulty.__frequent_token_ids.append(token_id)
				"2_rare":
					difficulty.__rare_token_ids.append(token_id)
				"3_scarce":
					difficulty.__scarce_token_ids.append(token_id)
				"4_unique":
					difficulty.__unique_token_ids.append(token_id)
				"5_never":
					pass
				_:
					assert(false, "id invalid " + token_id + " for set: "+Difficulty.as_string(id))
					
		difficulties.append(difficulty)
		
	game_manager.__set_difficulties(difficulties)
	
		
