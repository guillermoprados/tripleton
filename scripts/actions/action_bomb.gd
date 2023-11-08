extends TokenAction

class_name ActionBomb

func get_type() -> Constants.ActionType:
	return Constants.ActionType.BOMB
		
func is_valid_action(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	if cell_tokens_ids[action_cell.x][action_cell.y] != Constants.EMPTY_CELL:
		return Constants.ActionResult.VALID
	else:
		return Constants.ActionResult.WASTED
		
func __surrounding_cells(current_cell:Vector2) -> Array[Vector2]:
	var surrounding_cells : Array[Vector2] = []
#   disabling for now surrounding cells
#	surrounding_cells.append(current_cell + Vector2(0, - 1))
#	surrounding_cells.append(current_cell + Vector2(1, - 1))
#	surrounding_cells.append(current_cell + Vector2(1, 0))
#	surrounding_cells.append(current_cell + Vector2(1, 1))
#	surrounding_cells.append(current_cell + Vector2(0, 1))
#	surrounding_cells.append(current_cell + Vector2(- 1, - 1))
#	surrounding_cells.append(current_cell + Vector2(- 1, 0))
#   surrounding_cells.append(current_cell + Vector2(- 1, 1))
	return surrounding_cells
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	var cells : Array[Vector2] = []
	
	for surrounding_cell in __surrounding_cells(current_cell):
		if __is_valid_cell(surrounding_cell, cell_tokens_ids):
			cells.append(surrounding_cell)
	
	cells.append(current_cell)
	
	return cells	

	
