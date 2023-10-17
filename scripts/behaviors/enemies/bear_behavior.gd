extends EnemyTokenBehavior

class_name BearBehavior

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
		var next_empty_cell : Vector2 = find_next_empty_cell(current_cell, cell_tokens_ids) 
		if (current_cell != next_empty_cell):
			move_from_cell_to_cell.emit(current_cell, next_empty_cell, .2)
			# animate and then emit finish
			action_finished.emit()
		else:
			stuck_in_cell.emit(current_cell)
			action_finished.emit()
		
func find_next_empty_cell(current_cell:Vector2, cell_tokens_ids: Array) -> Vector2:
	
	var possible_moves = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,  
		Vector2.DOWN 
	]

	# Shuffle the possible moves to ensure randomness
	possible_moves.shuffle()

	for move in possible_moves:
		var next_cell = current_cell + move
		if is_valid_cell(next_cell, cell_tokens_ids) and cell_tokens_ids[next_cell.x][next_cell.y] == Constants.EMPTY_CELL:
			return next_cell

	return current_cell  # Return current cell if no moves found, can be changed to null if needed.

