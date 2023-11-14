extends StateBase

class_name StateStart

var __fade_out := true

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.START

func _on_state_entered() -> void:
	pass
	
# override in states
func _on_state_exited() -> void:
	if __fade_out:
		game_manager.gameplay_ui.fade_to_transparent()

func _process(delta:float) -> void:
	state_finished.emit(id)
