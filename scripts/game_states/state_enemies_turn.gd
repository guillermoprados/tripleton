extends StateBase

class_name StateEnemiesTurn

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ENEMIES
	
var number_of_pending_actions : int
var stucked_enemies : Array[Vector2]

var enemies: Dictionary

# override in states	
func _on_state_entered() -> void:
	number_of_pending_actions = 0
	stucked_enemies = []
	enemies = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		enemies[key].behavior.action_finished.connect(self._on_enemy_action_finished)
		enemies[key].behavior.stuck_in_cell.connect(self._on_stucked_enemy)
		number_of_pending_actions += 1
		enemies[key].behavior.execute_action(key, board.cell_tokens_ids)
		
# override in states
func _on_state_exited() -> void:
	for key in enemies:
		enemies[key].behavior.action_finished.disconnect(self._on_enemy_action_finished)
		enemies[key].behavior.stuck_in_cell.disconnect(self._on_stucked_enemy)
	enemies = {}

func _on_enemy_action_finished() -> void:
	number_of_pending_actions -= 1

func _on_stucked_enemy(cell_index:Vector2) -> void:
	stucked_enemies.append(cell_index)
	
func check_dead_enemies() -> void:
	for cell_index in stucked_enemies:
		var enemy_token: Token = board.get_token_at_cell(cell_index)
		var next_token_data: TokenData = enemy_token.data.next_token
		var grave_token:Token = game_manager.instantiate_new_token(next_token_data, cell_index, null)
		board.clear_token(cell_index)
		board.set_token_at_cell(grave_token, cell_index)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if number_of_pending_actions == 0:
		check_dead_enemies()
		finish_enemies_turn()
	
func finish_enemies_turn() -> void:
	state_finished.emit(id)
