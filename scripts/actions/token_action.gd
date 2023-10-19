extends Node

class_name TokenAction

signal action_finished()	
signal move_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float)
signal swap_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float)
signal stuck_in_cell(cell_index:Vector2)

func is_valid_action() -> bool:
	return false

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	assert(false, "this is not implemented in child")
