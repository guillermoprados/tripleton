class_name Combinator extends Node

@export var token_data_info_provider: TokenDataProvider

var board: Board

var combinations: Dictionary  

func _ready():
	board = get_parent()
	reset_combinations()

func reset_combinations() -> void:
	combinations = {}
	for row in board.cells_matrix:
		for cell in row:
			var cell_index = cell.cell_index
			combinations[cell_index] = Combination.new(cell_index)

# This is the method that starts the search of a combination
func search_combinations_for_cell(floating_token_id: int, cell_index: Vector2) -> Combination:
	CombinationClusterProcessor.evaluate_combination(floating_token_id, combinations[cell_index], board.cells_matrix, token_data_info_provider)
	return combinations[cell_index]

func get_combinations_for_cell(cell_index: Vector2) -> Combination:
	return combinations[cell_index]

func combine_tokens(combination: Combination) -> TokenData:
	var next_token_data:TokenData = null
	
	for cell_index in combination.combinable_cells:
		var token_id = board.cell_tokens_ids[cell_index]
		board.clear_token(cell_index)

		# Add the combination result
		if cell_index == combination.initial_cell():
			var token_type = token_data_info_provider.get_combination_type_for_token(token_id)
			var level = combination.level_reached() + 1
			# if level >= token_data_info_provider.get_number_of_levels_for_token_id(token_id):
			#	token_type = "chests"  # Assuming chests is the category you want to default to
			#	level = 0
			next_token_data = token_data_info_provider.get_token_data(token_type, level)
			# board.set_token_at_cell(cell_index, next_token_data.id)

	return next_token_data
