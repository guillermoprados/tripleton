extends EnemyTokenBehavior

class_name RollerBehavior

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
		var next_empty_cell : Vector2 = find_random_empty_cell_in_line(current_cell, cell_tokens_ids) 
		if (current_cell != next_empty_cell):
			move_in_board.emit(current_cell, next_empty_cell, .2)
			# animate and then emit finish
			action_finished.emit()
		else:
			stuck_in_cell.emit(current_cell)
			action_finished.emit()
		
func find_continuous_empty_cell_in_line(current_cell: Vector2, cell_tokens_ids: Array, direction: Vector2) -> Array[Vector2]:
	var continuous_empty_cells: Array[Vector2] = []
	var next_cell = current_cell + direction
	
	while is_valid_cell(next_cell, cell_tokens_ids) and cell_tokens_ids[next_cell.x][next_cell.y] == Constants.EMPTY_CELL:
		continuous_empty_cells.append(next_cell)
		next_cell += direction
	
	return continuous_empty_cells
	
	
func find_random_empty_cell_in_line(current_cell: Vector2, cell_tokens_ids: Array) -> Vector2:
	var possible_moves = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,  
		Vector2.DOWN 
	]
	
	var all_empty_cells: Array = []
	for move in possible_moves:
		var empty_cells_in_line = find_continuous_empty_cell_in_line(current_cell, cell_tokens_ids, move)
		all_empty_cells += empty_cells_in_line
	
	if all_empty_cells.size() > 0:
		return all_empty_cells[randi() % all_empty_cells.size()]
	else:
		return current_cell
