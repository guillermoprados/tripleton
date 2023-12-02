extends StateBase

class_name StateGameOver

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.GAME_OVER
	
func _on_state_entered() -> void:
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.GAME_OVER)
	game_manager.gameplay_ui.play_again.connect(_on_ui_play_again)
	
func _on_state_exited() -> void:
	game_manager.gameplay_ui.play_again.disconnect(_on_ui_play_again)
	pass

func _on_ui_play_again() -> void:
	get_tree().reload_current_scene()
