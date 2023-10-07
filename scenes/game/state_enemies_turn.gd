extends StateBase

class_name StateEnemiesTurn

var number_of_pending_actions : int

var enemies: Dictionary

# override in states	
func _on_state_entered() -> void:
	number_of_pending_actions = 0
	enemies = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		enemies[key].behavior.action_finished.connect(self._on_enemy_action_finished)
		number_of_pending_actions += 1
		enemies[key].behavior.execute_action(key, board.cell_tokens_ids)
		
# override in states
func _on_state_exited() -> void:
	for key in enemies:
		enemies[key].behavior.action_finished.disconnect(self._on_enemy_action_finished)
	enemies = {}

func _on_enemy_action_finished() -> void:
	number_of_pending_actions -= 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if number_of_pending_actions == 0:
		finish_enemies_turn()
	
func finish_enemies_turn() -> void:
	switch_state.emit(Constants.PlayingState.PLAYER)
