extends TokenAction

class_name ActionRemoveAll

func get_type() -> Constants.ActionType:
	return Constants.ActionType.REMOVE_ALL
		
func action_check_result_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	var result:Constants.ActionResult = Constants.ActionResult.VALID
	if __is_cell_empty(action_cell, cell_tokens_ids):
		result = Constants.ActionResult.WASTED
	else:
		var on_board_token_type := __token.get_other_token_data_util(cell_tokens_ids[action_cell.x][action_cell.y]).type()
		if on_board_token_type == Constants.TokenType.CHEST or on_board_token_type == Constants.TokenType.PRIZE:
			result = Constants.ActionResult.INVALID
		else:
			result = Constants.ActionResult.VALID
			
	return result
		
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	var cells : Array[Vector2] = []
	
	var cell_token_id := __token.get_other_token_data_util(cell_tokens_ids[current_cell.x][current_cell.y]).id
	
	for row in range(cell_tokens_ids.size()):
		for col in range(cell_tokens_ids[0].size()):
			if cell_token_id == cell_tokens_ids[row][col]:
				cells.append(Vector2(row, col))
				
	return cells	

	
