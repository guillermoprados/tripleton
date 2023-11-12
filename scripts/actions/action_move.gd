extends TokenAction

class_name ActionMove

func get_type() -> Constants.ActionType:
	return Constants.ActionType.MOVE

func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	var result:Constants.ActionResult = Constants.ActionResult.INVALID
	
	if cell_tokens_ids[action_cell.x][action_cell.y] != Constants.EMPTY_CELL:
		if affected_cells(action_cell, cell_tokens_ids).size() > 0:
			result = Constants.ActionResult.VALID
	else:
		result = Constants.ActionResult.WASTED
	
	return result 

func __is_cell_suitable_to_move(to_move_cell:Vector2, cell_tokens_ids: Array):
	return __is_valid_cell(to_move_cell, cell_tokens_ids) and cell_tokens_ids[to_move_cell.x][to_move_cell.y] == Constants.EMPTY_CELL
		
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	var cells:Array[Vector2] = []
	
	var up_cell = current_cell + Vector2(-1,0)
	
	if __is_cell_suitable_to_move(up_cell, cell_tokens_ids):
		cells.append(up_cell)
		
	var down_cell = current_cell + Vector2(1,0)
	
	if __is_cell_suitable_to_move(down_cell, cell_tokens_ids):
		cells.append(down_cell)
	
	var left_cell = current_cell + Vector2(0,-1)
	
	if __is_cell_suitable_to_move(left_cell, cell_tokens_ids):
		cells.append(left_cell)
	
	var right_cell = current_cell + Vector2(0,1)
	
	if __is_cell_suitable_to_move(right_cell, cell_tokens_ids):
		cells.append(right_cell)
	
	return cells
	
	
