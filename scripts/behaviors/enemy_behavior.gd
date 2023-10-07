extends TokenBehavior

class_name EnemyTokenBehavior

signal  move_in_board(from_cell:Vector2, to_cell:Vector2, transition_time:float)

func find_next_empty_cell(current_cell:Vector2, cell_tokens_ids: Array) -> Vector2:
	return current_cell
	
func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()
