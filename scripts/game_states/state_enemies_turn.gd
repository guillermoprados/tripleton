extends StateBase

class_name StateEnemiesTurn

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ENEMIES
	
var number_of_pending_actions : int

var __inner_state:int = 0
const STATE_ACTIONS:int = 1
const STATE_HIGHLIGHT_LAST:int = 2
const STATE_DONE:int = 3

# override in states	
func _on_state_entered() -> void:
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
		STATE_HIGHLIGHT_LAST:
			__highlight_groups()
		STATE_DONE:
			finish_enemies_turn()
	
	__inner_state += 1

func __highlight_groups() -> void:
	var groups := EnemiesHelper.find_enclosed_groups(board)
	
	for group in groups:
		if group.size() > Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION - 1:
			__highlight_last_created(group)
		else:
			__clear_group_hihglights(group)
	
func finish_enemies_turn() -> void:	
	state_finished.emit(id)

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
