extends TokenAction

class_name ActionLevelUp

func get_type() -> Constants.ActionType:
	return Constants.ActionType.LEVEL_UP
		
func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	if __is_cell_empty(action_cell, cell_tokens_ids):
		return Constants.ActionResult.WASTED
	else:
		var board_token_data = __token.get_other_token_data_util(cell_tokens_ids[action_cell.x][action_cell.y])
		if board_token_data.type() == Constants.TokenType.NORMAL and \
			board_token_data is TokenCombinableData and \
			(board_token_data as TokenCombinableData).has_next_token() and \
			board_token_data.next_token.type() == Constants.TokenType.NORMAL:
			return Constants.ActionResult.VALID
		else:
			return Constants.ActionResult.INVALID

func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	return [current_cell]

	
