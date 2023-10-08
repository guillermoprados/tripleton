extends StateBase

class_name StateCheckGame

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.CHECK
	
# override in states	
func _on_state_entered() -> void:
	if not can_place_more_tokens(board.cell_tokens_ids):
		game_finished()
	else:
		state_finished.emit(id)
		
# override in states
func _on_state_exited() -> void:
	pass

func can_place_more_tokens(cell_tokens_ids: Array) -> bool:
	var empty_cells: Array = []
	
	for x in range(cell_tokens_ids.size()):
		for y in range(cell_tokens_ids[x].size()):
			if cell_tokens_ids[x][y] == Constants.EMPTY_CELL:
				empty_cells.append(Vector2(x, y))
				
	#TODO: check save token cell 
	return empty_cells.size() > 0
	
func game_finished() -> void:
	switch_state.emit(Constants.PlayingState.GAME_OVER)
