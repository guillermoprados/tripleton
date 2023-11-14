extends Node

class_name TokenAction

func get_type() -> Constants.ActionType:
	assert(false, "this is must be implemented in child")
	return Constants.ActionType.NONE
		
var __token:BoardToken:
	get:
		var token = get_parent().get_parent()
		assert(token is BoardToken, "the action is not configured properly")
		return token
		
func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	assert(false, "this is must be implemented in child")
	return Constants.ActionResult.INVALID
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	assert(false, "this is must be implemented in child")
	return []
	
func __is_cell_empty(cell:Vector2, cell_tokens_ids: Array) -> bool:
	return cell_tokens_ids[cell.x][cell.y] == Constants.EMPTY_CELL
