extends TokenBehavior

class_name EnemyTokenBehavior

signal  move_in_board(from_cell:Vector2, to_cell:Vector2, transition_time:float)
signal  stuck_in_cell(cell_index:Vector2)

func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()
