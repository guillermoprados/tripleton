extends StateBase

class_name StateEnemiesTurn

@export var grave_data:TokenData

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.ENEMIES
	
var number_of_pending_actions : int
var check_stucked_enemies: bool
var merge_graves: bool
var highlight_groups: bool
var stucked_enemies : Array[Vector2]

# override in states	
func _on_state_entered() -> void:
	assert(grave_data, "Grave Data needed to merge graves")
	number_of_pending_actions = 0
	check_stucked_enemies = true
	merge_graves = false # will be set only if there are dead enemies
	highlight_groups = true
	stucked_enemies = []
	var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		enemies[key].unhighlight()
		number_of_pending_actions += 1
		__bind_enemy_actions(enemies[key])
		enemies[key].behavior.execute(key, board.cell_tokens_ids)
		
# override in states
func _on_state_exited() -> void:
	var enemies: Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		__unbind_enemy_actions(enemies[key])
	enemies = {}

func __bind_enemy_actions(token:BoardToken) -> void:
	token.behavior.behaviour_finished.connect(self._on_enemy_behaviour_finished)
	token.behavior.move_from_cell_to_cell.connect(self._on_enemy_movement)
	token.behavior.stuck_in_cell.connect(self._on_stucked_enemy)

func __unbind_enemy_actions(token:BoardToken) -> void:
	token.behavior.behaviour_finished.disconnect(self._on_enemy_behaviour_finished)
	token.behavior.move_from_cell_to_cell.disconnect(self._on_enemy_movement)
	token.behavior.stuck_in_cell.disconnect(self._on_stucked_enemy)
	
func _on_enemy_behaviour_finished() -> void:
	number_of_pending_actions -= 1

func _on_stucked_enemy(cell_index:Vector2) -> void:
	stucked_enemies.append(cell_index)
	
func _on_enemy_movement(from_cell:Vector2, to_cell:Vector2, transition_time:float, tween_start_delay:float) -> void:
	game_manager.move_token_in_board(from_cell, to_cell, transition_time, tween_start_delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	
	if number_of_pending_actions > 0:
		return
	
	if check_stucked_enemies:
		__transform_dead_enemies()
		check_stucked_enemies = false
		return
	
	if merge_graves:
		__merge_graves()
		merge_graves = false
	
	if highlight_groups:
		__highlight_groups()
		highlight_groups = false
		return
			
	finish_enemies_turn()

func __transform_dead_enemies() -> void:
	if stucked_enemies.size() > 0:
		var simplified_board_info:Array = __convert_board_to_array(board, game_manager.can_place_more_tokens())	
		merge_graves = __check_dead_enemies(simplified_board_info)	
		
func __merge_graves() -> void:
	var graves:Array = board.get_tokens_with_id(grave_data.id).keys()
	game_manager.check_and_do_board_combinations(graves, Constants.MergeType.BY_LAST_CREATED)
	
func __highlight_groups() -> void:
	var simplified_board_info:Array = __convert_board_to_array(board, game_manager.can_place_more_tokens())
	__highlight_last_in_groups(simplified_board_info)
	
func finish_enemies_turn() -> void:	
	state_finished.emit(id)

func __check_dead_enemies(simplified_board:Array) -> bool:
	var dead_enemies:bool = false
	var can_place_more_tokens:bool = game_manager.can_place_more_tokens()
	
	for cell_index in stucked_enemies:
		if not __can_reach_empty_cell(cell_index, simplified_board):
			var enemy_token:BoardToken = board.get_token_at_cell(cell_index)
			var should_kill_enemy : bool = false
			# jumping enemies are not considered here, since they always can reach empty cells
			if (enemy_token.data as TokenEnemyData).enemy_type == Constants.EnemyType.MOLE:
				if !can_place_more_tokens:
					should_kill_enemy = true
			else:
				should_kill_enemy = true
			
			if should_kill_enemy:
				game_manager.set_dead_enemy(cell_index)
				dead_enemies = true
				__unbind_enemy_actions(enemy_token)
	
	return dead_enemies
	
func __highlight_last_in_groups(simplified_board:Array) -> void:
	
	var groups = __find_enclosed_groups(simplified_board)
	
	for group in groups:
		if group.size() > Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION - 1:
			var last_enemy : BoardToken = __find_last_created(group)
			last_enemy.set_highlight(Constants.TokenHighlight.LAST) 

enum PathCellType {
	PATH,
	ENEMY,
	WALL
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
			if board[next_pos.x][next_pos.y] == PathCellType.PATH:
				# Found an empty cell
				return true
			elif board[next_pos.x][next_pos.y] == PathCellType.ENEMY:
				# Add enemy cell to the queue for further exploration
				queue.append(next_pos)
	
	# No path found to an empty cell
	return false

func __convert_board_to_array(board: Board, can_place_more_tokens:bool) -> Array:
	var converted_board = []
	
	# Iterating through all cells in the board
	for i in range(board.rows):
		var row = []
		
		for j in range(board.columns):
			var cell_index = Vector2(i, j)
			
			# Check if the cell is empty
			if board.is_cell_empty(cell_index):
				row.append(PathCellType.PATH)
				continue
			
			# Check if there's a token at the cell
			var token = board.get_token_at_cell(cell_index)
			
			#mole enemies are like paths
			if token and token.type == Constants.TokenType.ENEMY:
				if (token.data as TokenEnemyData).enemy_type == Constants.EnemyType.MOLE and can_place_more_tokens:
					row.append(PathCellType.PATH)
				else:
					row.append(PathCellType.ENEMY)
			else:
				row.append(PathCellType.WALL)
		
		# Append the row to the converted_board
		converted_board.append(row)
	
	return converted_board

func __find_enclosed_groups(board: Array) -> Array:
	var visited = []
	for i in range(board.size()):
		var row = []
		for j in range(board[i].size()):
			row.append(false)
		visited.append(row)

	var groups = []
	
	for i in range(board.size()):
		for j in range(board[i].size()):
			if board[i][j] == PathCellType.ENEMY and not visited[i][j]:
				var current_group = []
				__fill_group(i, j, board, visited, current_group)
				if current_group.size():
					groups.append(current_group)

	return groups

func __fill_group(i: int, j: int, board: Array, visited: Array, current_group: Array) -> void:
	if i < 0 or j < 0 or i >= board.size() or j >= board[i].size() or visited[i][j] or board[i][j] == PathCellType.WALL:
		return

	visited[i][j] = true

	if board[i][j] == PathCellType.ENEMY:
		current_group.append(Vector2(i, j))
		
	__fill_group(i-1, j, board, visited, current_group)
	__fill_group(i+1, j, board, visited, current_group)
	__fill_group(i, j-1, board, visited, current_group)
	__fill_group(i, j+1, board, visited, current_group)

func __find_last_created(group:Array) -> BoardToken:
	assert(group.size() > 0, "groups info should be bigger than 0")
	var last_created_token: BoardToken = board.get_token_at_cell(group[0])
	for pos in group:
		var other_token: BoardToken = board.get_token_at_cell(pos)
		if other_token.created_at > last_created_token.created_at:
			last_created_token = other_token
	return last_created_token
			
		
# Example Usage
#var groups = find_enclosed_groups(converted_board)
