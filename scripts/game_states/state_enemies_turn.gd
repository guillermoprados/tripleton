extends StateBase

class_name StateEnemiesTurn

@export var grave_data:TokenData
@export var combinator: Combinator

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ENEMIES
	
var number_of_pending_actions : int

var __inner_state = 0
const STATE_ACTIONS = 1
const STATE_CHECK_STUCK_ENEMIES = 2
const STATE_MERGE_GRAVES = 3
const STATE_HIGHLIGHT_LAST = 4
const STATE_DONE = 5

# override in states	
func _on_state_entered() -> void:
	assert(grave_data, "Grave Data needed to merge graves")
	__inner_state = 0
	number_of_pending_actions = 0
		
# override in states
func _on_state_exited() -> void:
	var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		__unbind_enemy_actions(enemies[key])
	enemies = {}

func __bind_enemy_actions(token:BoardToken) -> void:
	token.behavior.behaviour_finished.connect(self._on_enemy_behaviour_finished)
	token.behavior.move_from_cell_to_cell.connect(self._on_enemy_movement)

func __unbind_enemy_actions(token:BoardToken) -> void:
	token.behavior.behaviour_finished.disconnect(self._on_enemy_behaviour_finished)
	token.behavior.move_from_cell_to_cell.disconnect(self._on_enemy_movement)
	
func _on_enemy_behaviour_finished() -> void:
	number_of_pending_actions -= 1
	
func _on_enemy_movement(from_cell:Vector2, to_cell:Vector2, transition_time:float, tween_start_delay:float) -> void:
	game_manager.move_token_in_board(from_cell, to_cell, transition_time, tween_start_delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	
	if number_of_pending_actions > 0:
		return
	
	match __inner_state:
		STATE_ACTIONS:
			var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
			for key in enemies:
				number_of_pending_actions += 1
				__bind_enemy_actions(enemies[key])
				enemies[key].behavior.execute(key, board.cell_tokens_ids)
		STATE_CHECK_STUCK_ENEMIES:
			__transform_dead_enemies()
		STATE_MERGE_GRAVES:
			__merge_graves()
		STATE_HIGHLIGHT_LAST:
			__highlight_groups()
		STATE_DONE:
			finish_enemies_turn()
	
	__inner_state += 1

func __transform_dead_enemies() -> void:
	var stucked_enemies = EnemiesHelper.find_stucked_enemies_cells(board)
	if stucked_enemies.size() > 0:
		var simplified_board_info:Array = EnemiesHelper.get_enemy_and_path_simplified_board(board)	
		__check_dead_enemies(stucked_enemies, simplified_board_info)	
		
func __merge_graves() -> void:
	var graves:Array = board.get_tokens_with_id(grave_data.id).keys()
	combinator.reset_combinations(board.rows, board.columns)
	game_manager.check_and_do_board_combinations(graves, Constants.MergeType.BY_LAST_CREATED)
	
func __highlight_groups() -> void:
	var simplified_board_info:Array = EnemiesHelper.get_enemy_and_path_simplified_board(board)
	__highlight_last_in_groups(simplified_board_info)
	
func finish_enemies_turn() -> void:	
	state_finished.emit(id)

func __check_dead_enemies(stucked_enemies:Array, simplified_board:Array) -> bool:
	var dead_enemies:bool = false
	var can_place_more_tokens:bool = game_manager.can_place_more_tokens()
	
	for cell_index in stucked_enemies:
		var enemy_token:BoardToken = board.get_token_at_cell(cell_index)
		var should_kill_enemy : bool = false
		# jumping enemies are not considered here, since they always can reach empty cells
		if (enemy_token.data as TokenEnemyData).enemy_type == Constants.EnemyType.MOLE:
			if !can_place_more_tokens:
				should_kill_enemy = true
		else:
			should_kill_enemy = true
		
		if should_kill_enemy:
			game_manager.set_dead_enemy(cell_index)
			dead_enemies = true
			__unbind_enemy_actions(enemy_token)
		
	return dead_enemies
	
func __highlight_last_in_groups(simplified_board:Array) -> void:
	
	var groups = EnemiesHelper.find_enclosed_groups(simplified_board)
	
	for group in groups:
		if group.size() > Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION - 1:
			__highlight_last_created(group)
		else:
			__clear_group_hihglights(group)

func __highlight_last_created(group:Array) -> void:
	assert(group.size() > 0, "groups info should be bigger than 0")
	var last_pos : Vector2 = group[0] 
	var last_created_token:BoardToken = board.get_token_at_cell(last_pos)
	for pos in group:
		var other_token: BoardToken = board.get_token_at_cell(pos)
		if other_token.created_at > last_created_token.created_at:
			last_created_token = other_token
			last_pos = pos
		
	for pos in group:
		var token:BoardToken = board.get_token_at_cell(pos)
		if pos == last_pos:
			token.set_highlight(Constants.TokenHighlight.LAST)
		else:
			token.set_highlight(Constants.TokenHighlight.NONE)

func __clear_group_hihglights(group:Array) -> void:
	for pos in group:
		var token:BoardToken = board.get_token_at_cell(pos)
		token.set_highlight(Constants.TokenHighlight.NONE)
