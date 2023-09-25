extends Node


# The helper class for SingleLevelCombination
class CombinationLevel:
	
	var cross_compared_cells: Dictionary = {}
	var valid_combination_cells: Dictionary = {}

	func add_to_cross_compared(cell: Vector2) -> void:
		cross_compared_cells[cell] = true

	func add_to_valid_combination(cell: Vector2) -> void:
		valid_combination_cells[cell] = true

	func has_cross_compared(cell: Vector2) -> bool:
		return cell in cross_compared_cells

	func clear_valid_combination() -> void:
		valid_combination_cells.clear()
