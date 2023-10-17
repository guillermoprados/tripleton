class_name Board extends Node2D

signal board_cell_moved(index:Vector2)
signal board_cell_selected(index:Vector2)

@export var cell_scene: PackedScene
@export var rows: int = 6
@export var columns: int = 6

var cell_tokens_ids: Array = []  # The matrix of string values
var placed_tokens: Dictionary = {}  # Dictionary with cell indices as keys and token instances as values
var cells_matrix: Array = [] # The cells matrix so we can access them directly

var enabled_interaction: bool = false

func _ready() -> void:
	configure()	
	
func _process(delta:float) -> void:
	pass

func configure() -> void:
	
	__clear_board()
	
	var centered_x:float = (Constants.CELL_SIZE.x * columns) / 2
	var screen_size:Vector2 = get_tree().root.content_scale_size
	position.x = position.x - (columns * (Constants.CELL_SIZE.x/ 2))
	for row in range(rows):
		var row_tokens: Array = []
		var row_cells: Array = []  # This will store the cell references for this row
		for col in range(columns):
			row_tokens.append(Constants.EMPTY_CELL)  # Initializing matrix with EMPTY_CELL value
			var cell_instance: BoardCell = cell_scene.instantiate()
	
			# Connect the cell signals to the board methods using the new syntax
			cell_instance.cell_entered.connect(self._on_cell_entered)
			cell_instance.cell_exited.connect(self._on_cell_exited)
			cell_instance.cell_selected.connect(self._on_cell_selected)
			
			cell_instance.position = Vector2(col * Constants.CELL_SIZE.x, row * Constants.CELL_SIZE.y)
			cell_instance.cell_index = Vector2(row, col)
			add_child(cell_instance)
			row_cells.append(cell_instance)
		cell_tokens_ids.append(row_tokens)
		cells_matrix.append(row_cells)  # Storing the row of cells into the matrix

func __clear_board() -> void:
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
func set_token_at_cell(token:Token, cell_index: Vector2) -> void:
	
	assert(cell_tokens_ids[cell_index.x][cell_index.y] == Constants.EMPTY_CELL, "there is a token already here!")
	
	cell_tokens_ids[cell_index.x][cell_index.y] = token.id
	placed_tokens[cell_index] = token
	add_child(token)
	token.position = get_cell_at_position(cell_index).position

func clear_token(cell_index: Vector2) -> void:
	# Update the matrix value to EMPTY_CELL
	cell_tokens_ids[cell_index.x][cell_index.y] = Constants.EMPTY_CELL
	
	# Remove the token instance from the scene if it exists in the dictionary
	if placed_tokens.has(cell_index):
		var token:Token = placed_tokens[cell_index]
		token.queue_free()  # Safely remove the token from the scene
		placed_tokens.erase(cell_index)  # Remove the token from the dictionary

func move_token_from_to(cell_index_from:Vector2, cell_index_to:Vector2, tween_time:float):
	assert(cell_index_from != cell_index_to, "cannot move to the same cell") 
	assert(cell_tokens_ids[cell_index_from.x][cell_index_from.y] != Constants.EMPTY_CELL, "cannot move from "+str(cell_index_from)+ " empty token?")
	assert(cell_tokens_ids[cell_index_to.x][cell_index_to.y] == Constants.EMPTY_CELL, "cannot move to "+str(cell_index_to))
	
	cell_tokens_ids[cell_index_to.x][cell_index_to.y] = cell_tokens_ids[cell_index_from.x][cell_index_from.y]
	placed_tokens[cell_index_to] = placed_tokens[cell_index_from]
	
	if tween_time <= 0:
		placed_tokens[cell_index_from].position = get_cell_at_position(cell_index_to).position
	else:
		var tween = create_tween()
		tween.tween_property(placed_tokens[cell_index_from], "position", get_cell_at_position(cell_index_to).position, tween_time)
	
	cell_tokens_ids[cell_index_from.x][cell_index_from.y] = Constants.EMPTY_CELL
	placed_tokens.erase(cell_index_from)
	
func get_token_at_cell(cell_index: Vector2) -> Token:
	return placed_tokens[cell_index]

func get_number_of_empty_cells() -> int:
	var total_cells:int = rows * columns
	# Subtract the count of placed tokens
	var empty_cells:int = total_cells - placed_tokens.size()
	return empty_cells
	
# Get the cell scene at a given position
func get_cell_at_position(cell_index: Vector2) -> Node:
	if cell_index.x < rows and cell_index.y < columns:
		return cells_matrix[cell_index.x][cell_index.y]
	return null  # Return null if the position is out of bounds

# Check if the cell is empty
func is_cell_empty(cell_index: Vector2) -> bool:
	return cell_tokens_ids[cell_index.x][cell_index.y] == Constants.EMPTY_CELL

func _on_cell_entered(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	set_hovering_on_cell(cell_index)
	board_cell_moved.emit(cell_index)
	
func _on_cell_exited(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	pass
	
func _on_cell_selected(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	board_cell_selected.emit(cell_index)

func clear_highlights() -> void:
	for row in cells_matrix:
		for cell in row:
			cell.highlight(Constants.HighlightMode.NONE, true)
			
func set_hovering_on_cell(cell_index: Vector2) -> void:
	clear_highlights()

	var can_place_token:bool = is_cell_empty(cell_index)

	for row in cells_matrix:
		for cell in row:
			if cell.cell_index == cell_index:
				cell.highlight(Constants.HighlightMode.HOVER, can_place_token)
			elif cell.cell_index.x == cell_index.x or cell.cell_index.y == cell_index.y:
				cell.highlight(Constants.HighlightMode.SAME_LINE, can_place_token)

func get_tokens_of_type(type:Constants.TokenType) -> Dictionary:
	var filtered_tokens = {}
	for key in placed_tokens:
		if placed_tokens[key].type == type:
			filtered_tokens[key] = placed_tokens[key]
	return filtered_tokens
