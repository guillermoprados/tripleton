extends RefCounted

class Combination:

	# Member variables
	var evaluated : bool = false
	var cell_index : Vector2  # corresponds to BoardCellIndex
	var combinable_cells : Array = []
	var last_level_reached : int = 0	
	
	# Properties
	func is_valid():
		return combinable_cells.size() >= Constants.MinRequiredTokensForCombination

	func initial_cell():
		return cell_index

	func level_reached():
		return last_level_reached

	# Constructor
	func _init(cell_idx : Vector2) -> void:
		self.cell_index = cell_idx

	func add_data(cells: Array, new_last_level_reached: int) -> void:
		for cell in cells:
			combinable_cells.append(cell)
		
		if new_last_level_reached > last_level_reached:
			last_level_reached = new_last_level_reached
