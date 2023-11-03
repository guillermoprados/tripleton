extends TokenBehavior

class_name MoleBehavior

func execute_behavior(current_cell:Vector2, cell_tokens_ids: Array) -> void:
		var next_empty_cell : Vector2 = find_random_empty_cell(cell_tokens_ids) 
		if next_empty_cell != Constants.INVALID_CELL:
			move_from_cell_to_cell.emit(current_cell, next_empty_cell, 0, 0)
			# animate and then emit finish
			behaviour_finished.emit()
		else:
			stuck_in_cell.emit(current_cell)
			behaviour_finished.emit()
		
func find_random_empty_cell(cell_tokens_ids: Array) -> Vector2:
	var empty_cells: Array = []
	
	for x in range(cell_tokens_ids.size()):
		for y in range(cell_tokens_ids[x].size()):
			if cell_tokens_ids[x][y] == Constants.EMPTY_CELL:
				empty_cells.append(Vector2(x, y))
				
	if empty_cells.size() == 0:
		return Constants.INVALID_CELL  # Return the current cell if no empty cells are found

	# Return a random empty cell
	return empty_cells[randi() % empty_cells.size()]


