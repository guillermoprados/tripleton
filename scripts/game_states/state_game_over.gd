extends StateBase

class_name StateGameOver

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.GAME_OVER
	
func _on_state_entered() -> void:
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.GAME_OVER)
	
# override in states
func _on_state_exited() -> void:
	pass

