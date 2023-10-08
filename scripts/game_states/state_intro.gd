extends StateBase

class_name StateIntro

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.INTRO
	
func _on_state_entered() -> void:
	pass
# override in states
func _on_state_exited() -> void:
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.INTRO)
	pass

func _process(delta:float) -> void:
	state_finished.emit(id)
