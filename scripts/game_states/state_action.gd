extends StateBase

class_name  StateAction

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ACTION
	
# override in states	
func _on_state_entered() -> void:	
	assert(game_manager.user_action != Constants.ActionType.NONE, "shouldn't be here then")
	#board.enabled_interaction = true
	match action_type:
		Constants.ActionType.BOMB:
			execute_bomb_action()
	
# override in states
func _on_state_exited() -> void:
	#disable_interactions()
	pass
	
func _on_board_board_cell_moved(index:Vector2) -> void:
	pass	
func _on_board_board_cell_selected(index:Vector2) -> void:
	pass
	
func disable_interactions() -> void:
	board.enabled_interaction = false

func execute_bomb_action() -> void:
	game_manager.bomb_cell(game_manager.action_token)
