class_name Combinator extends Node

@export var token_data_info_provider: TokenDataProvider

var combinations: Dictionary  

func reset_combinations(rows:int, columns:int) -> void:
	combinations = {}
	for row_index in range(rows):
		for col_index in range(columns):
			var cell_index = Vector2(row_index, col_index)
			combinations[cell_index] = Combination.new(cell_index)

# This is the method that starts the search of a combination
func search_combinations_for_cell(floating_token_id: int, cell_index: Vector2, board_token_ids: Array) -> Combination:
	CombinationClusterProcessor.evaluate_combination(floating_token_id, combinations[cell_index], board_token_ids, token_data_info_provider)
	return combinations[cell_index]

func get_combinations_for_cell(cell_index: Vector2) -> Combination:
	return combinations[cell_index]
