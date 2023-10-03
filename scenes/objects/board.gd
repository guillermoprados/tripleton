class_name Board extends Node2D

signal board_cell_moved(index:Vector2)
signal board_cell_selected(index:Vector2)

@export var cell_scene: PackedScene
@export var default_rows: int = 5
@export var default_columns: int = 5

var board_size: Vector2 = Vector2.ZERO # Store the cell size for external access
var rows: int
var columns: int
var cell_size: Vector2 = Vector2.ZERO  # Store the cell size for external access
var cell_tokens_ids: Array = []  # The matrix of string values
var placed_tokens: Dictionary = {}  # Dictionary with cell indices as keys and token instances as values
var cells_matrix: Array = [] # The cells matrix so we can access them directly

func _ready():
	rows = default_rows
	columns = default_columns
	configure(rows, columns)	
	
func _process(delta):
	pass

func configure(rows: int, columns: int):
	__clear_board()
	
	self.rows = rows
	self.columns = columns
	
	for row in range(rows):
		var row_tokens: Array = []
		var row_cells: Array = []  # This will store the cell references for this row
		for col in range(columns):
			row_tokens.append(Constants.EMPTY_CELL)  # Initializing matrix with EMPTY_CELL value
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

func __clear_board():
	# Clear cell instances
	for row in cells_matrix:
		for cell in row:
			cell.queue_free()
	cells_matrix.clear()
	cell_tokens_ids.clear()

	# Clear token instances
	for token_pos in placed_tokens.keys():
		placed_tokens[token_pos].queue_free()
	placed_tokens.clear()
	
# Set the token for a specific cell
func set_token_at_cell(token:Token, cell_index: Vector2):
	cell_tokens_ids[cell_index.x][cell_index.y] = token.id
	placed_tokens[cell_index] = token
	add_child(token)
	token.position = get_cell_at_position(cell_index).position
	
func clear_token(cell_index: Vector2) -> void:
	# Update the matrix value to EMPTY_CELL
	cell_tokens_ids[cell_index.x][cell_index.y] = Constants.EMPTY_CELL
	
	# Remove the token instance from the scene if it exists in the dictionary
	if placed_tokens.has(cell_index):
		var token = placed_tokens[cell_index]
		token.queue_free()  # Safely remove the token from the scene
		placed_tokens.erase(cell_index)  # Remove the token from the dictionary

func get_token_at_cell(cell_index: Vector2) -> Token:
	return placed_tokens[cell_index]

# Get the cell scene at a given position
func get_cell_at_position(cell_index: Vector2) -> Node:
	if cell_index.x < rows and cell_index.y < columns:
		return cells_matrix[cell_index.x][cell_index.y]
	return null  # Return null if the position is out of bounds

# Check if the cell is empty
func is_cell_empty(cell_index: Vector2) -> bool:
	return cell_tokens_ids[cell_index.x][cell_index.y] == Constants.EMPTY_CELL

func _on_cell_entered(cell_index: Vector2):
	set_hovering_on_cell(cell_index)
	board_cell_moved.emit(cell_index)
	
func _on_cell_exited(cell_index: Vector2):
	pass
	
func _on_cell_selected(cell_index: Vector2):
	board_cell_selected.emit(cell_index)

func clear_highlights():
	for row in cells_matrix:
		for cell in row:
			cell.highlight(Constants.HighlightMode.NONE, true)
			
func set_hovering_on_cell(cell_index: Vector2):
	clear_highlights()

	var can_place_token = is_cell_empty(cell_index)

	for row in cells_matrix:
		for cell in row:
			if cell.cell_index == cell_index:
				cell.highlight(Constants.HighlightMode.HOVER, can_place_token)
			elif cell.cell_index.x == cell_index.x or cell.cell_index.y == cell_index.y:
				cell.highlight(Constants.HighlightMode.SAME_LINE, can_place_token)
