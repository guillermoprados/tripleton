extends RefCounted

class_name EnemiesHelper

enum PathCellType {
	PATH,
	ENEMY,
	WALL
}

static func __get_enemy_and_path_simplified_board(board: Board, jumping_enemies_as_path:bool) -> Array:
	var converted_board := []
	var board_has_empty_cells := board.get_number_of_empty_cells() > 0
	# Iterating through all cells in the board
	for i in range(board.rows):
		var row := []
		
		for j in range(board.columns):
			var cell_index := Vector2(i, j)
			
			# Check if the cell is empty
			if board.is_cell_empty(cell_index):
				row.append(PathCellType.PATH)
				continue
			
			# Check if there's a token at the cell
			var token := board.get_token_at_cell(cell_index)
			
			#mole enemies are like paths
			if token and token.type == Constants.TokenType.ENEMY:
				if jumping_enemies_as_path and (token.data as TokenEnemyData).enemy_type == Constants.EnemyType.MOLE and board_has_empty_cells:
					row.append(PathCellType.PATH)
				else:
					row.append(PathCellType.ENEMY)
			else:
				row.append(PathCellType.WALL)
		
		# Append the row to the converted_board
		converted_board.append(row)
	
	return converted_board
	
static func find_stucked_enemies_cells(board:Board) -> Array[Vector2]:
	var stucked_enemies_cells :Array[Vector2] = []
	var enemies_by_cell := board.get_tokens_of_type(Constants.TokenType.ENEMY)
	var path_cell_type_board := __get_enemy_and_path_simplified_board(board, true)
	for cell:Vector2 in enemies_by_cell.keys():
		var enemy := board.get_token_at_cell(cell)
		var enemy_behavior:TokenBehavior = enemy.behavior
		if not enemy_behavior.has_some_available_move(cell, board.cell_tokens_ids):
			if not __enemy_can_reach_empty_cell(cell, path_cell_type_board):
				stucked_enemies_cells.append(cell)
		
	return stucked_enemies_cells

static func __enemy_can_reach_empty_cell(start_pos: Vector2, board: Array) -> bool:
	var directions := [
		Vector2(0, 1),  # Down
		Vector2(1, 0),  # Right
		Vector2(0, -1), # Up
		Vector2(-1, 0)  # Left
	]
	
	var visited := {}  # A Dictionary to keep track of visited cells
	var queue := []    # An Array to use as a queue for BFS
	
	# Start BFS from the starting position
	queue.append(start_pos)
	visited[start_pos] = true
	
	while queue.size() > 0:
		var current:Vector2 = queue.pop_front()
		
		# Check for each possible direction
		for dir:Vector2 in directions:
			var next_pos :Vector2 = current + dir
			
			# Check for out-of-bounds
			if next_pos.x < 0 or next_pos.x >= board.size() or next_pos.y < 0 or next_pos.y >= board[0].size():
				continue
			
			# Check if the next position was visited before
			if visited.has(next_pos):
				continue
				
			# Mark the position as visited
			visited[next_pos] = true
			
			# Check the type of cell at next_pos
			if board[next_pos.x][next_pos.y] == PathCellType.PATH:
				# Found an empty cell
				return true
			elif board[next_pos.x][next_pos.y] == PathCellType.ENEMY:
				# Add enemy cell to the queue for further exploration
				queue.append(next_pos)
	
	# No path found to an empty cell
	return false

static func find_enclosed_groups(board:Board) -> Array:
	var simplified_board := __get_enemy_and_path_simplified_board(board, false)
	var visited := []
	for i in range(simplified_board.size()):
		var row := []
		for j in range(simplified_board[i].size()):
			row.append(false)
		visited.append(row)

	var groups := []
	
	for i in range(simplified_board.size()):
		for j in range(simplified_board[i].size()):
			if simplified_board[i][j] == PathCellType.ENEMY and not visited[i][j]:
				var current_group := []
				__fill_group(i, j, simplified_board, visited, current_group)
				if current_group.size():
					groups.append(current_group)

	return groups

static func __fill_group(i: int, j: int, board: Array, visited: Array, current_group: Array) -> void:
	if i < 0 or j < 0 or i >= board.size() or j >= board[i].size() or visited[i][j] or board[i][j] == PathCellType.WALL:
		return

	visited[i][j] = true

	if board[i][j] == PathCellType.ENEMY:
		current_group.append(Vector2(i, j))
		
	__fill_group(i-1, j, board, visited, current_group)
	__fill_group(i+1, j, board, visited, current_group)
	__fill_group(i, j-1, board, visited, current_group)
	__fill_group(i, j+1, board, visited, current_group)
