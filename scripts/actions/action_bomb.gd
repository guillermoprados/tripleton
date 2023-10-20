extends TokenAction

class_name ActionBomb

func __surrounding_cells(current_cell:Vector2) -> Array[Vector2]:
	print("current_cell: "+str(current_cell))
	var surrounding_cells : Array[Vector2] = []
	surrounding_cells.append(current_cell + Vector2(0, - 1))
	surrounding_cells.append(current_cell + Vector2(1, - 1))
	surrounding_cells.append(current_cell + Vector2(1, 0))
	surrounding_cells.append(current_cell + Vector2(1, 1))
	surrounding_cells.append(current_cell + Vector2(0, 1))
	surrounding_cells.append(current_cell + Vector2(- 1, - 1))
	surrounding_cells.append(current_cell + Vector2(- 1, 0))
	surrounding_cells.append(current_cell + Vector2(- 1, 1))
	print("surrounding_cells: "+str(surrounding_cells))
	return surrounding_cells
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	var cells : Array[Vector2] = []
	
	for surrounding_cell in __surrounding_cells(current_cell):
		if is_valid_cell(surrounding_cell, cell_tokens_ids):
			cells.append(surrounding_cell)
	
	cells.append(current_cell)
	
	return cells
	
func is_valid_action(action_cell:Vector2, cell_tokens_ids: Array) -> bool:
	return true

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	for cell in affected_cells(current_cell, cell_tokens_ids):
		remove_token_from_cell.emit(cell)
	action_finished.emit()

	
	
