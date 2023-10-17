extends StateBase

class_name StateEnemiesTurn

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ENEMIES
	
var number_of_pending_actions : int
var stucked_enemies : Array[Vector2]

var enemies: Dictionary

# override in states	
func _on_state_entered() -> void:
	number_of_pending_actions = 0
	stucked_enemies = []
	enemies = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		number_of_pending_actions += 1
		enemies[key].behavior.action_finished.connect(self._on_enemy_action_finished)
		enemies[key].behavior.move_from_cell_to_cell.connect(self._on_enemy_movement)
		enemies[key].behavior.stuck_in_cell.connect(self._on_stucked_enemy)
		
		enemies[key].behavior.execute_action(key, board.cell_tokens_ids)
		
# override in states
func _on_state_exited() -> void:
	for key in enemies:
		enemies[key].behavior.action_finished.disconnect(self._on_enemy_action_finished)
		enemies[key].behavior.move_from_cell_to_cell.disconnect(self._on_enemy_movement)
		enemies[key].behavior.stuck_in_cell.disconnect(self._on_stucked_enemy)
	enemies = {}

func _on_enemy_action_finished() -> void:
	number_of_pending_actions -= 1

func _on_stucked_enemy(cell_index:Vector2) -> void:
	stucked_enemies.append(cell_index)
	
func __check_dead_enemies() -> void:
	var simplified_board_info:Array = __convert_board_to_array(board)
	var check_graves:bool = false
	for cell_index in stucked_enemies:
		if not __can_reach_empty_cell(cell_index, simplified_board_info):
			game_manager.set_dead_enemy(cell_index)
			check_graves = true
	if check_graves:		
		game_manager.check_and_do_board_combinations(stucked_enemies)			
	
func _on_enemy_movement(from_cell:Vector2, to_cell:Vector2, transition_time:float) -> void:
	game_manager.move_token_in_board(from_cell, to_cell, transition_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if stucked_enemies.size() > 0:
		__check_dead_enemies()
		
	if number_of_pending_actions == 0:
		finish_enemies_turn()
	
func finish_enemies_turn() -> void:
	state_finished.emit(id)


enum CellType {
	EMPTY,
	ENEMY,
	OTHER
}

func __can_reach_empty_cell(start_pos: Vector2, board: Array) -> bool:
	var directions = [
		Vector2(0, 1),  # Down
		Vector2(1, 0),  # Right
		Vector2(0, -1), # Up
		Vector2(-1, 0)  # Left
	]
	
	var visited = {}  # A Dictionary to keep track of visited cells
	var queue = []    # An Array to use as a queue for BFS
	
	# Start BFS from the starting position
	queue.append(start_pos)
	visited[start_pos] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		# Check for each possible direction
		for dir in directions:
			var next_pos = current + dir
			
			# Check for out-of-bounds
			if next_pos.x < 0 or next_pos.x >= board.size() or next_pos.y < 0 or next_pos.y >= board[0].size():
				continue
			
			# Check if the next position was visited before
			if visited.has(next_pos):
				continue
				
			# Mark the position as visited
			visited[next_pos] = true
			
			# Check the type of cell at next_pos
			if board[next_pos.x][next_pos.y] == CellType.EMPTY:
				# Found an empty cell
				return true
			elif board[next_pos.x][next_pos.y] == CellType.ENEMY:
				# Add enemy cell to the queue for further exploration
				queue.append(next_pos)
	
	# No path found to an empty cell
	return false

func __convert_board_to_array(board: Board) -> Array:
	var converted_board = []
	
	# Iterating through all cells in the board
	for i in range(board.rows):
		var row = []
		
		for j in range(board.columns):
			var cell_index = Vector2(i, j)
			
			# Check if the cell is empty
			if board.is_cell_empty(cell_index):
				row.append(CellType.EMPTY)
				continue
			
			# Check if there's a token at the cell
			var token = board.get_token_at_cell(cell_index)
			
			if token and token.type == Constants.TokenType.ENEMY:
				row.append(CellType.ENEMY)
			else:
				row.append(CellType.OTHER)
		
		# Append the row to the converted_board
		converted_board.append(row)
	
	return converted_board
