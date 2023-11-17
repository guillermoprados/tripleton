extends TokenAction

class_name ActionBomb

func get_type() -> Constants.ActionType:
	return Constants.ActionType.BOMB
		
func action_check_result_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	var result:Constants.ActionResult = Constants.ActionResult.VALID
	if __is_cell_empty(action_cell, cell_tokens_ids):
		result = Constants.ActionResult.WASTED
	else:
		if __token.get_other_token_data_util(cell_tokens_ids[action_cell.x][action_cell.y]).type() == Constants.TokenType.CHEST:
			result = Constants.ActionResult.INVALID
		else:
			result = Constants.ActionResult.VALID
			
	return result
		
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
		if Utils.is_valid_cell(surrounding_cell, cell_tokens_ids):
			cells.append(surrounding_cell)
	
	cells.append(current_cell)
	
	return cells	

	
