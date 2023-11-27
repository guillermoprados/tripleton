extends Node

class_name TokenBehavior

signal behaviour_finished()	
signal move_from_cell_to_cell(from_cell:Vector2, to_cell:Vector2, transition_time:float, tween_start_delay:float)

var __paralized:bool = false
var paralize:bool:
	get:
		return __paralized
	set(value):
		# todo: animate paralized
		__paralized = value

func execute(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	if __paralized:
		## animate paralized?
		behaviour_finished.emit()
		return
	
	var available_moves := __find_available_movements(current_cell, cell_tokens_ids)
		
	if available_moves.size() > 0:
		var next_cell = __select_next_move_cell(available_moves)
		var await_time:float = __animate_to_cell_and_get_wait_time(current_cell, next_cell)
		await get_tree().create_timer(await_time).timeout
	
	behaviour_finished.emit()
	
func has_some_available_move(current_cell:Vector2, cell_tokens_ids: Array) -> bool:
	return __find_available_movements(current_cell, cell_tokens_ids).size() > 0
	
func __select_next_move_cell(available_moves:Array) -> Vector2:
	assert(available_moves.size() > 0, "trying to move when there are not available moves")
	var randomIndex := randi() % available_moves.size()
	return available_moves[randomIndex]
	
func __find_available_movements(current_cell:Vector2, cell_tokens_ids: Array) -> Array:
	assert(false, "this is not implemented in child")
	return []

func __animate_to_cell_and_get_wait_time(current_cell:Vector2, to_cell:Vector2) -> float:
	assert(false, "this is not implemented in child")
	return 0
	
func __execute_behavior(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	assert(false, "this is not implemented in child")
