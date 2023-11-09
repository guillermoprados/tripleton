extends Node

class_name TokenAction

func get_type() -> Constants.ActionType:
	assert(false, "this is must be implemented in child")
	return Constants.ActionType.NONE
		
func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	assert(false, "this is must be implemented in child")
	return Constants.ActionResult.NOT_VALID
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	assert(false, "this is must be implemented in child")
	return []
	
func __is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()
