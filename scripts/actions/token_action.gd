extends Node

class_name TokenAction

signal action_finished()	
signal move_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float)
signal swap_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float)
signal stuck_in_cell(cell_index:Vector2)

func is_valid_action(action_cell:Vector2, cell_tokens_ids: Array) -> bool:
	assert(false, "this is must be implemented in child")
	return false

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	assert(false, "this is must implemented in child")

func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()
