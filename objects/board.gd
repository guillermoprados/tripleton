class_name Board extends Node2D

const EMPTY_CELL = -1

signal board_cell_moved(index:Vector2)
signal board_cell_selected(index:Vector2)

@export var cell_scene: PackedScene

var board_size: Vector2 = Vector2.ZERO # Store the cell size for external access
var rows: int
var columns: int
var cell_size: Vector2 = Vector2.ZERO  # Store the cell size for external access
var cell_tokens_ids: Array = []  # The matrix of int values
var placed_tokens: Dictionary = {}  # Dictionary with cell indices as keys and token instances as values
var cells_matrix: Array = [] # The cells matrix so we can access them directly

func _ready():
	rows = 6
	columns = 6
	create_board(rows, columns)	
	
func _process(delta):
	pass

func create_board(rows: int, columns: int):
	for row in range(rows):
		var row_tokens: Array = []
		var row_cells: Array = []  # This will store the cell references for this row
		for col in range(columns):
			row_tokens.append(EMPTY_CELL)  # Initializing matrix with EMPTY_CELL value
			var cell_instance = cell_scene.instantiate()
	
			# Connect the cell signals to the board methods using the new syntax
			cell_instance.cell_entered.connect(self._on_cell_entered)
			cell_instance.cell_exited.connect(self._on_cell_exited)
			cell_instance.cell_selected.connect(self._on_cell_selected)
			
			if cell_size == Vector2.ZERO:  # Only assign cell_size once
				cell_size = cell_instance.size()
	
			cell_instance.position = Vector2(col * cell_size.x, row * cell_size.y)
			cell_instance.cell_index = Vector2(row, col)
			add_child(cell_instance)
			row_cells.append(cell_instance)
		cell_tokens_ids.append(row_tokens)
		cells_matrix.append(row_cells)  # Storing the row of cells into the matrix
	
	board_size = Vector2(columns * cell_size.x, rows * cell_size.y)
	
# Set the token for a specific cell
func set_token_at_cell(token, cell_pos: Vector2):
	cell_tokens_ids[cell_pos.x][cell_pos.y] = token.id
	placed_tokens[cell_pos] = token
	add_child(token)
	token.position = get_cell_at_position(cell_pos).position
	
func clear_token(cell_index: Vector2) -> void:
	# Update the matrix value to EMPTY_CELL
	cell_tokens_ids[cell_index.x][cell_index.y] = EMPTY_CELL
	
	# Remove the token instance from the scene if it exists in the dictionary
	if placed_tokens.has(cell_index):
		var token = placed_tokens[cell_index]
		token.queue_free()  # Safely remove the token from the scene
		placed_tokens.erase(cell_index)  # Remove the token from the dictionary


# Get the token at a specific cell
func get_token_at_cell(cell_pos: Vector2) -> int:
	return cell_tokens_ids[cell_pos.x][cell_pos.y]

# Get the cell scene at a given position
func get_cell_at_position(cell_pos: Vector2) -> Node:
	if cell_pos.x < rows and cell_pos.y < columns:
		return cells_matrix[cell_pos.x][cell_pos.y]
	return null  # Return null if the position is out of bounds

# Check if the cell is empty
func is_cell_empty(cell_pos: Vector2) -> bool:
	return cell_tokens_ids[cell_pos.x][cell_pos.y] == EMPTY_CELL

func reset_board_to_empty():
	for row in cell_tokens_ids:
		for i in range(row.size()):
			row[i] = EMPTY_CELL

func _on_cell_entered(cell_pos: Vector2):
	set_hovering_on_cell(cell_pos)
	board_cell_moved.emit(cell_pos)
	
func _on_cell_exited(cell_pos: Vector2):
	pass
	
func _on_cell_selected(cell_pos: Vector2):
	board_cell_selected.emit(cell_pos)

func clear_current_hovering():
	for row in cells_matrix:
		for cell in row:
			cell.highlight(Constants.HighlightMode.NONE, true)
			
func set_hovering_on_cell(cell_pos: Vector2):
	clear_current_hovering()

	var can_place_token = is_cell_empty(cell_pos)

	for row in cells_matrix:
		for cell in row:
			if cell.cell_index == cell_pos:
				cell.highlight(Constants.HighlightMode.HOVER, can_place_token)
			elif cell.cell_index.x == cell_pos.x or cell.cell_index.y == cell_pos.y:
				cell.highlight(Constants.HighlightMode.SAME_LINE, can_place_token)
