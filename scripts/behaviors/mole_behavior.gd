extends TokenBehavior

class_name MoleBehavior

func __execute_behavior(current_cell:Vector2, cell_tokens_ids: Array) -> void:
		var available_cells := __find_available_movements(current_cell, cell_tokens_ids)
		var next_empty_cell : Vector2 = __select_next_move_cell(available_cells) 
		if next_empty_cell != Constants.INVALID_CELL:
			move_from_cell_to_cell.emit(current_cell, next_empty_cell, 0, 0)
			# animate and then emit finish
			behaviour_finished.emit()
		else:
			behaviour_finished.emit()

func __find_available_movements(current_cell:Vector2, cell_tokens_ids: Array) -> Array:
	var empty_cells: Array = []
	for x in range(cell_tokens_ids.size()):
		for y in range(cell_tokens_ids[x].size()):
			if cell_tokens_ids[x][y] == Constants.EMPTY_CELL:
				empty_cells.append(Vector2(x, y))
	return empty_cells

func __select_next_move_cell(available_moves:Array) -> Vector2:
	assert(available_moves.size() > 0, "trying to move when there are not available moves")
	var randomIndex := randi() % available_moves.size()
	return available_moves[randomIndex]

func __animate_to_cell_and_get_wait_time(current_cell:Vector2, to_cell:Vector2) -> float:
	assert(false, "this is not implemented in child")
	return 0
	



