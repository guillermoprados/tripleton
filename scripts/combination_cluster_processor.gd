
class CombinationClusterProcessor:

	# The primary evaluation method
	func evaluate_combination(floating_token_id: int, combination: Combination, board_tokens: Array, token_info_provider: TokenDataInfoProvider) -> void:
		if not combination.evaluated:
			combination.evaluated = true

			var token_id = floating_token_id
			var first_level = token_info_provider.get_level_for_token_id(token_id)
			var number_of_levels = token_info_provider.get_number_of_levels_for_token_id(token_id)
			for level in range(first_level, number_of_levels):
				var combination_level = SingleLevelCombination.new()
				_search_combination_for_cell(token_id, board_tokens, combination.initial_cell(), combination_level, true)
				token_id = token_info_provider.get_token_id_for_next_level(token_id)
				if combination_level.valid_combination_cells.size() >= Constants.GameplayRules.MinRequiredTokensForCombination:
					combination.add_data(combination_level.valid_combination_cells, level)
				else:
					# discard the level and stop
					combination_level.valid_combination_cells.clear()
					break

	# Helper method to search combination for cell
	func _search_combination_for_cell(token_id: int, board: IGameBoard, current_cell: Vector2, combination_level: SingleLevelCombination, is_origin: bool) -> void:
		if is_origin:
			combination_level.cross_compared_cells.add(current_cell)
			combination_level.valid_combination_cells.add(current_cell)
			_search_cross_combination_for_cell(token_id, board, current_cell, combination_level)
		elif combination_level.cross_compared_cells.has(current_cell):  # this cell has already been compared
			return
		elif token_id == board[current_cell]:  # Assuming board implements _get_item_ to access elements like this
			combination_level.cross_compared_cells.add(current_cell)
			combination_level.valid_combination_cells.add(current_cell)
			_search_cross_combination_for_cell(token_id, board, current_cell, combination_level)

	# Helper method to search cross combination for cell
	func _search_cross_combination_for_cell(token_id: int, board: IGameBoard, center_cell: Vector2, combination_level: SingleLevelCombination) -> void:
		# top
		if center_cell.y > 0:
			_search_combination_for_cell(token_id, board, Vector2(center_cell.x, center_cell.y - 1), combination_level, false)
		# down
		if center_cell.y < board.rows - 1:
			_search_combination_for_cell(token_id, board, Vector2(center_cell.x, center_cell.y + 1), combination_level, false)
		# left
		if center_cell.x > 0:
			_search_combination_for_cell(token_id, board, Vector2(center_cell.x - 1, center_cell.y), combination_level, false)
		# right
		if center_cell.x < board.columns - 1:
			_search_combination_for_cell(token_id, board, Vector2(center_cell.x + 1, center_cell.y), combination_level, false)
