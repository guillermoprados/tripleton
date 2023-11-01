extends TokenBehavior

class_name BearBehavior

@export var animator:EnemyAnimator

const JUMP_ANIM_START_DELAY_TIME = 0.2

func execute_behavior(current_cell:Vector2, cell_tokens_ids: Array) -> void:
		var next_empty_cell : Vector2 = find_next_empty_cell(current_cell, cell_tokens_ids) 
		if (current_cell != next_empty_cell):
			animator.jump()
			move_from_cell_to_cell.emit(current_cell, next_empty_cell, .2, JUMP_ANIM_START_DELAY_TIME)
			# animate and then emit finish
			behaviour_finished.emit()
		else:
			stuck_in_cell.emit(current_cell)
			behaviour_finished.emit()
		
func find_next_empty_cell(current_cell:Vector2, cell_tokens_ids: Array) -> Vector2:
	
	var possible_moves = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,  
		Vector2.DOWN 
	]

	# Shuffle the possible moves to ensure randomness
	possible_moves.shuffle()

	for move in possible_moves:
		var next_cell = current_cell + move
		if is_valid_cell(next_cell, cell_tokens_ids) and cell_tokens_ids[next_cell.x][next_cell.y] == Constants.EMPTY_CELL:
			return next_cell

	return current_cell  # Return current cell if no moves found, can be changed to null if needed.

