extends StateBase

class_name StateCheckGame

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.CHECK
	
# override in states	
func _on_state_entered() -> void:
	if not game_manager.can_place_more_tokens():
		game_finished()
	else:
		state_finished.emit(id)
		
# override in states
func _on_state_exited() -> void:
	pass
	
func game_finished() -> void:
	switch_state.emit(Constants.PlayingState.GAME_OVER)
