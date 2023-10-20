extends TokenAction

class_name ActionMove

enum MoveDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var move_direction : MoveDirection

func _ready():
	move_direction = randi() % 4 as MoveDirection
	
	match move_direction:
		MoveDirection.UP:
			get_parent().rotation_degrees = 0  # Assuming default is facing up
		MoveDirection.RIGHT:
			get_parent().rotation_degrees = 90
		MoveDirection.DOWN:
			get_parent().rotation_degrees = 180
		MoveDirection.LEFT:
			get_parent().rotation_degrees = 270

func __get_next_cell(current_cell:Vector2, direction:MoveDirection) -> Vector2:
	var next_cell = current_cell
	match move_direction:
		MoveDirection.UP:
			next_cell.x -= 1
		MoveDirection.DOWN:
			next_cell.x += 1
		MoveDirection.LEFT:
			next_cell.y -= 1
		MoveDirection.RIGHT:
			next_cell.y += 1
	return next_cell
	
func is_valid_action(action_cell:Vector2, cell_tokens_ids: Array) -> bool:
	var valid : bool = false
	
	var next_cell = __get_next_cell(action_cell, move_direction)
	
	if is_valid_cell(next_cell, cell_tokens_ids):
		valid = cell_tokens_ids[next_cell.x][next_cell.y] == Constants.EMPTY_CELL
	
	return valid

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	move_from_cell_to_cell.emit(current_cell, __get_next_cell(current_cell, move_direction), .2)
	action_finished.emit()

	
	
