class_name Combination extends RefCounted

# Member variables
var evaluated : bool = false
var cell_index : Vector2
var combinable_cells : Array = []
var last_level_reached : int = 0	

# Constructor
func _init(cell_idx : Vector2) -> void:
	self.cell_index = cell_idx

func is_valid() -> bool:
	return combinable_cells.size() >= Constants.MIN_REQUIRED_TOKENS_FOR_COMBINATION

func initial_cell() -> Vector2:
	return cell_index

func level_reached() -> int:
	return last_level_reached

func add_data(cells: Array, new_last_level_reached: int) -> void:
	for cell in cells:
		combinable_cells.append(cell)
	
	if new_last_level_reached > last_level_reached:
		last_level_reached = new_last_level_reached
