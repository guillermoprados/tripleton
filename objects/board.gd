extends Node2D

var CellScript = preload("res://objects/cell.gd")

const EMPTY_CELL = -1

@export var level_config: Resource
@export var cell_scene: PackedScene

var board_size: Vector2 = Vector2.ZERO # Store the cell size for external access
var rows: int
var columns: int
var cell_size: Vector2 = Vector2.ZERO  # Store the cell size for external access
var cell_tokens: Array = []  # The matrix of int values
var last_placed_token_position: Vector2 = Vector2.ZERO

func _ready():
	if level_config:
		rows = level_config.rows
		columns = level_config.columns
		create_board(rows, columns)	

func _process(delta):
	pass

func create_board(rows: int, columns: int):
	for row in range(rows):
		var row_tokens: Array = []
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
		
		cell_tokens.append(row_tokens)
	board_size = Vector2(columns * cell_size.x, rows * cell_size.y)
	# set some default placed position
	last_placed_token_position = Vector2.ZERO

# Set the token for a specific cell
func set_token_at_cell(token_id: int, cell_pos: Vector2):
	cell_tokens[cell_pos.x][cell_pos.y] = token_id
	last_placed_token_position = cell_pos

# Get the token at a specific cell
func get_token_at_cell(cell_pos: Vector2) -> int:
	return cell_tokens[cell_pos.x][cell_pos.y]

# Check if the cell is empty
func is_cell_empty(cell_pos: Vector2) -> bool:
	return cell_tokens[cell_pos.x][cell_pos.y] == EMPTY_CELL

func reset_board_to_empty():
	for row in cell_tokens:
		for i in range(row.size()):
			row[i] = EMPTY_CELL

func get_closer_empty_cell_to_last_token() -> Vector2:
	var nearest_empty_pos = Vector2.ZERO
	var nearest_distance = INF

	for row in range(rows):
		for col in range(columns):
			var cell_index = Vector2(row, col)

			if is_cell_empty(cell_index):
				var distance = cell_index.distance_to(last_placed_token_position)
				if distance < nearest_distance:
					nearest_distance = distance
					nearest_empty_pos = cell_index

	return nearest_empty_pos

func _on_cell_entered(cell_pos: Vector2):
	set_hovering_on_cell(cell_pos)
	
func _on_cell_exited(cell_pos: Vector2):
	print('exited ', cell_pos)
	
func _on_cell_selected(cell_pos: Vector2):
	print('selected ', cell_pos)

func clear_current_hovering():
	for cell in get_tree().get_nodes_in_group("cells"):
		cell.highlight(CellScript.HighlightMode.NONE, true)

func set_hovering_on_cell(cell_pos: Vector2):
	clear_current_hovering()

	var can_place_token = is_cell_empty(cell_pos)

	for cell in get_tree().get_nodes_in_group("cells"):
		if cell.cell_index == cell_pos:
			cell.highlight(CellScript.HighlightMode.HOVER, can_place_token)
		elif cell.cell_index.x == cell_pos.x or cell.cell_index.y == cell_pos.y:
			cell.highlight(CellScript.HighlightMode.SAME_LINE, can_place_token)
