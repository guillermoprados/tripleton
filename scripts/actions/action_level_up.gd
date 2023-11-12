extends TokenAction

class_name ActionLevelUp

@export var all_tokens_data: AllTokensData

func get_type() -> Constants.ActionType:
	return Constants.ActionType.LEVEL_UP
		
func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	if cell_tokens_ids[action_cell.x][action_cell.y] != Constants.EMPTY_CELL:
		var board_token_data = all_tokens_data.get_token_data_by_id(cell_tokens_ids[action_cell.x][action_cell.y])
		if board_token_data.type() == Constants.TokenType.NORMAL and board_token_data is TokenCombinableData and (board_token_data as TokenCombinableData).has_next_token():
			return Constants.ActionResult.VALID
		else:
			return Constants.ActionResult.INVALID
	else:
		return Constants.ActionResult.WASTED
		
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	return [current_cell]

	
