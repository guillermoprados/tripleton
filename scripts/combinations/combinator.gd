class_name Combinator extends Node

var combinations: Dictionary  

func reset_combinations(rows:int, columns:int) -> void:
	combinations = {}
	for row_index in range(rows):
		for col_index in range(columns):
			var cell_index:Vector2 = Vector2(row_index, col_index)
			combinations[cell_index] = Combination.new(cell_index)

func clear_evaluated_combination(cell_index:Vector2):
	if combinations[cell_index].evaluated:
		combinations[cell_index].evaluated = false
# This is the method that starts the search of a combination
func search_combinations_for_cell(placed_token: TokenData, cell_index: Vector2, board_token_ids: Array, recursive_levels:bool) -> Combination:
	if !combinations[cell_index].evaluated:
		__evaluate_combination(placed_token, combinations[cell_index], board_token_ids, recursive_levels)
	return combinations[cell_index]

func get_combinations_for_cell(cell_index: Vector2) -> Combination:
	return combinations[cell_index]
	
# this is only useful for wildcards
func replace_combination_at_cell(combination:Combination, cell_index:Vector2) -> void:
	combinations[cell_index] = combination

# The primary evaluation method
static func __evaluate_combination(initial_token: TokenData, combination: Combination, board_tokens_ids: Array, recursive_levels:bool) -> void:
	
	combination.evaluated = true

	if not initial_token is TokenCombinableData:
		return
		
	var evaluating_token: TokenCombinableData = initial_token
	var level:int = 0
	
	while evaluating_token.has_next_token():
		var combination_level:CombinationLevel = CombinationLevel.new()
		__search_combination_for_cell(evaluating_token.id, board_tokens_ids, combination.initial_cell(), combination_level, true)
		
		if combination_level.valid_combination_cells.size() >= Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION:
			combination.add_data(combination_level.get_valid_combination_cells(), level)
			if !recursive_levels:
				break
		else:
			# discard the level and stop
			combination_level.valid_combination_cells.clear()
			break
		
		evaluating_token = evaluating_token.next_token
			
	# if I want to evaluate chests for prize levels I have to do it here as well

# Helper method to search combination for cell
static func __search_combination_for_cell(token_id: String, board_tokens_ids: Array, current_cell: Vector2, combination_level: CombinationLevel, is_origin: bool) -> void:
	if is_origin:
		combination_level.add_to_cross_compared(current_cell)
		combination_level.add_to_valid_combination(current_cell)
		__search_cross_combination_for_cell(token_id, board_tokens_ids, current_cell, combination_level)
	elif combination_level.cross_compared_cells.has(current_cell):  # this cell has already been compared
		return
	elif token_id == board_tokens_ids[current_cell.x][current_cell.y]:
		combination_level.add_to_cross_compared(current_cell)
		combination_level.add_to_valid_combination(current_cell)
		__search_cross_combination_for_cell(token_id, board_tokens_ids, current_cell, combination_level)

# Helper method to search cross combination for cell
static func __search_cross_combination_for_cell(token_id: String, board_tokens_ids: Array, center_cell: Vector2, combination_level: CombinationLevel) -> void:
	# top
	if center_cell.y > 0:
		__search_combination_for_cell(token_id, board_tokens_ids, Vector2(center_cell.x, center_cell.y - 1), combination_level, false)
	# down
	if center_cell.y < board_tokens_ids.size() - 1:
		__search_combination_for_cell(token_id, board_tokens_ids, Vector2(center_cell.x, center_cell.y + 1), combination_level, false)
	# left
	if center_cell.x > 0:
		__search_combination_for_cell(token_id, board_tokens_ids, Vector2(center_cell.x - 1, center_cell.y), combination_level, false)
	# right
	if center_cell.x < board_tokens_ids[0].size() - 1:
		__search_combination_for_cell(token_id, board_tokens_ids, Vector2(center_cell.x + 1, center_cell.y), combination_level, false)
