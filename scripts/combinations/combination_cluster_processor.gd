
class_name CombinationClusterProcessor extends RefCounted

# The primary evaluation method
static func evaluate_combination(floating_token_id: int, combination: Combination, board_tokens_ids: Array, token_info_provider: TokenDataProvider) -> void:
	if not combination.evaluated:
		combination.evaluated = true

		var token_id = floating_token_id
		var first_level = token_info_provider.get_level_for_token_id(token_id)
		var number_of_levels = token_info_provider.get_number_of_levels_for_token_id(token_id)
		for level in range(first_level, number_of_levels):
			var combination_level = CombinationLevel.new()
			__search_combination_for_cell(token_id, board_tokens_ids, combination.initial_cell(), combination_level, true)
			token_id = token_info_provider.get_token_id_for_next_level(token_id)
			if combination_level.valid_combination_cells.size() >= Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION:
				combination.add_data(combination_level.get_valid_combination_cells(), level)
			else:
				# discard the level and stop
				combination_level.valid_combination_cells.clear()
				break

# Helper method to search combination for cell
static func __search_combination_for_cell(token_id: int, board_tokens_ids: Array, current_cell: Vector2, combination_level: CombinationLevel, is_origin: bool) -> void:
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
static func __search_cross_combination_for_cell(token_id: int, board_tokens_ids: Array, center_cell: Vector2, combination_level: CombinationLevel) -> void:
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
