extends TokenBehavior

class_name MonokeloBehavior

@export var animator:EnemyAnimator

const JUMP_ANIM_START_DELAY_TIME = 0.2

func __animate_to_cell_and_get_wait_time(current_cell:Vector2, to_cell:Vector2) -> float:
		animator.jump()
		move_from_cell_to_cell.emit(current_cell, to_cell, .2, JUMP_ANIM_START_DELAY_TIME)
		return JUMP_ANIM_START_DELAY_TIME

func __find_available_movements(current_cell:Vector2, cell_tokens_ids: Array) -> Array:
	var possible_moves := [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,  
		Vector2.DOWN 
	]
	
	var available_moves : Array = []
	
	for move:Vector2 in possible_moves:
		var next_cell :Vector2 = current_cell + move
		if Utils.is_valid_cell(next_cell, cell_tokens_ids) and cell_tokens_ids[next_cell.x][next_cell.y] == Constants.EMPTY_CELL:
			available_moves.append(next_cell)
	
	return available_moves

