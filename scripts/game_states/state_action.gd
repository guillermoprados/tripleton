extends StateBase

class_name  StateAction

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ACTION
	
# override in states	
func _on_state_entered() -> void:	
	board.enabled_interaction = true

# override in states
func _on_state_exited() -> void:
	
	disable_interactions()
		
func _on_board_board_cell_moved(index:Vector2) -> void:
	pass	
func _on_board_board_cell_selected(index:Vector2) -> void:
	pass
	
func disable_interactions() -> void:
	board.enabled_interaction = false
