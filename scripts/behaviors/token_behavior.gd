extends Node

class_name TokenBehavior

signal behaviour_finished()	
signal move_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float, tween_start_delay:float)
signal stuck_in_cell(cell_index:Vector2)

var __paralized:bool = false
var paralize:bool:
	get:
		return __paralized
	set(value):
		# todo: animate paralized
		__paralized = value

func execute(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	if not __paralized:
		__execute_behavior(current_cell, cell_tokens_ids)
	else:
		behaviour_finished.emit()
		
func __execute_behavior(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	assert(false, "this is not implemented in child")
