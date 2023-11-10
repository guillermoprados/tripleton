class_name Board extends Node2D

signal board_cell_moved(index:Vector2)
signal board_cell_selected(index:Vector2)

@export var cell_scene: PackedScene
@export var rows: int = 6
@export var columns: int = 6
@export var tilemap: TileMap

var cell_tokens_ids: Array = []  # The matrix of string values
var placed_tokens: Dictionary = {}  # Dictionary with cell indices as keys and token instances as values
var cells_matrix: Array = [] # The cells matrix so we can access them directly
var floor_matrix: Array = []

var enabled_interaction: bool = false

const DEFAULT_FLOOR : Constants.FloorType = Constants.FloorType.PATH

func _ready() -> void:
	configure()	
	
func _process(delta:float) -> void:
	pass

func configure() -> void:
	__clear_board()
	z_index = Constants.BOARD_Z_INDEX
	
	for row in range(rows):
		var row_tokens: Array = []
		var row_cells: Array = []  # This will store the cell references for this row
		for col in range(columns):
			row_tokens.append(Constants.EMPTY_CELL)  # Initializing matrix with EMPTY_CELL value
			var cell_instance: BoardCell = cell_scene.instantiate()
			cell_instance.board_cell_position = Vector2(row, col)
			cell_instance.z_index = Constants.CELL_Z_INDEX
			
			# Connect the cell signals to the board methods using the new syntax
			cell_instance.cell_entered.connect(self._on_cell_entered)
			cell_instance.cell_exited.connect(self._on_cell_exited)
			cell_instance.cell_selected.connect(self._on_cell_selected)
			
			cell_instance.position = Vector2(col * Constants.CELL_SIZE.x, row * Constants.CELL_SIZE.y)
			cell_instance.position += Constants.CELL_SIZE / 2 # becauce cells are centered
			
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
	
	__clear_floor_matrix()

func __clear_floor_matrix():
	# Initialize the floor_matrix with default FloorType.PATH values
	for row in range(rows):
		var row_values = []
		for col in range(columns):
			row_values.append(Constants.FloorType.PATH)
		floor_matrix.append(row_values)
		
# Set the token for a specific cell
func set_token_at_cell(token:Token, cell_index: Vector2) -> void:
	
	assert(cell_tokens_ids[cell_index.x][cell_index.y] == Constants.EMPTY_CELL, "there is a token already here!" + str(cell_index))
	
	cell_tokens_ids[cell_index.x][cell_index.y] = token.id
	placed_tokens[cell_index] = token
	add_child(token)
	token.position = get_cell_at_position(cell_index).position
	token.z_index = Constants.TOKENS_Z_INDEX + cell_index.x
	
	__update_floor_tiles([cell_index])

func __update_floor_tiles(on_cells:Array[Vector2]) -> void:
	var cells_pert_type:Dictionary = {}
	
	#Constants.TILESET_TERRAIN_BACK
	cells_pert_type[Constants.FloorType.PATH] = [] as Array[Vector2i]
	cells_pert_type[Constants.FloorType.GRASS] = [] as Array[Vector2i]
	
	for cell_index in on_cells:
		var floor_type:Constants.FloorType = DEFAULT_FLOOR
		if placed_tokens.has(cell_index):
			var token:Token = placed_tokens[cell_index]
			floor_type = token.floor_type
		if floor_matrix[cell_index.x][cell_index.y] != floor_type:
			floor_matrix[cell_index.x][cell_index.y] = floor_type
			cells_pert_type[floor_type].append_array(__get_floor_sub_cells(cell_index))
	
	if cells_pert_type[Constants.FloorType.PATH].size() > 0:
		tilemap.set_cells_terrain_connect(0, cells_pert_type[Constants.FloorType.PATH], Constants.TILESET_TERRAIN_BOARD_SET, Constants.TILESET_TERRAIN_PATH, false)

	if cells_pert_type[Constants.FloorType.GRASS].size() > 0:
		tilemap.set_cells_terrain_connect(0, cells_pert_type[Constants.FloorType.GRASS], Constants.TILESET_TERRAIN_BOARD_SET, Constants.TILESET_TERRAIN_BACK, false)


func clear_token(cell_index: Vector2) -> void:
	
	# Remove the token instance from the scene if it exists in the dictionary
	if placed_tokens.has(cell_index):
		var token:Token = placed_tokens[cell_index]
		token.queue_free()  # Safely remove the token from the scene
		placed_tokens.erase(cell_index)  # Remove the token from the dictionary
		
	# Update the matrix value to EMPTY_CELL
	cell_tokens_ids[cell_index.x][cell_index.y] = Constants.EMPTY_CELL
	
	__update_floor_tiles([cell_index])
	
#TODO move all tiles functionality to the map
func change_back_texture(texture:CompressedTexture2D) -> void:
	tilemap.tile_set.get_source(0).texture = texture
	
func __get_floor_sub_cells(cell_index: Vector2) -> Array[Vector2i]:
	var sub_cells: Array[Vector2i] = []

	for row in range(cell_index.y * 2, cell_index.y * 2 + 2):
		for col in range(cell_index.x * 2, cell_index.x * 2 + 2):
			sub_cells.append(Vector2i(row, col))

	return sub_cells


func get_cells_with_floor_type(type: Constants.FloorType, inverted:bool) -> Array[Vector2i]:
	var matching_cells: Array[Vector2i] = []

	for row in range(rows):
		for col in range(columns):
			if floor_matrix[row][col] == type:
				if inverted:
					matching_cells.append(Vector2i(col, row))
				else:
					matching_cells.append(Vector2i(row, col))
					
	return matching_cells

	
func move_token_from_to(cell_index_from:Vector2, cell_index_to:Vector2, tween_time:float, tween_delay:float):
	assert(cell_index_from != cell_index_to, "cannot move to the same cell") 
	assert(cell_tokens_ids[cell_index_from.x][cell_index_from.y] != Constants.EMPTY_CELL, "cannot move from "+str(cell_index_from)+ " empty token?")
	assert(cell_tokens_ids[cell_index_to.x][cell_index_to.y] == Constants.EMPTY_CELL, "cannot move to "+str(cell_index_to))
	
	cell_tokens_ids[cell_index_to.x][cell_index_to.y] = cell_tokens_ids[cell_index_from.x][cell_index_from.y]
	placed_tokens[cell_index_to] = placed_tokens[cell_index_from]
	cell_tokens_ids[cell_index_from.x][cell_index_from.y] = Constants.EMPTY_CELL
	placed_tokens.erase(cell_index_from)
	
	if tween_delay > 0:
		await get_tree().create_timer(tween_delay).timeout
	
	if tween_time <= 0:
		placed_tokens[cell_index_to].position = get_cell_at_position(cell_index_to).position
	else:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(placed_tokens[cell_index_to], "position", get_cell_at_position(cell_index_to).position, tween_time)
	
	__update_floor_tiles([cell_index_from, cell_index_to])
	
func get_token_at_cell(cell_index: Vector2) -> Token:
	return placed_tokens[cell_index]

func get_empty_cells() -> Array[Vector2i]:
	var empty_cells: Array[Vector2i] = []

	for row in range(rows):
		for col in range(columns):
			if cell_tokens_ids[row][col] == Constants.EMPTY_CELL:
				empty_cells.append(Vector2i(row, col))

	return empty_cells
	
func get_number_of_empty_cells() -> int:
	var total_cells:int = rows * columns
	# Subtract the count of placed tokens
	var empty_cells:int = total_cells - placed_tokens.size()
	return empty_cells
	
# Get the cell scene at a given position
func get_cell_at_position(cell_index: Vector2) -> BoardCell:
	if cell_index.x < rows and cell_index.y < columns:
		return cells_matrix[cell_index.x][cell_index.y]
	return null  # Return null if the position is out of bounds

# Check if the cell is empty
func is_cell_empty(cell_index: Vector2) -> bool:
	return cell_tokens_ids[cell_index.x][cell_index.y] == Constants.EMPTY_CELL

func _on_cell_entered(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	board_cell_moved.emit(cell_index)
	
func _on_cell_exited(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	
	
func _on_cell_selected(cell_index: Vector2) -> void:
	if not enabled_interaction:
		return
	board_cell_selected.emit(cell_index)

func clear_highlights() -> void:
	for row in cells_matrix:
		for cell in row:
			cell.clear_highlight()
	for token_pos in placed_tokens.keys():
		var token: Token = placed_tokens[token_pos]
		if token.is_in_range:
			token.set_status(Constants.TokenStatus.PLACED)
			
func highligh_cell(cell_index: Vector2, mode:Constants.CellHighlight) -> void:
	get_cell_at_position(cell_index).highlight(mode)

func highlight_cells(cells:Array[Vector2], mode:Constants.CellHighlight) -> void:
	for cell_index in cells:
		get_cell_at_position(cell_index).highlight(mode)
		
func highlight_combination(initial_cell:Vector2, combination:Combination) -> void:
	for cell_index in combination.combinable_cells:
		get_cell_at_position(cell_index).highlight(Constants.CellHighlight.COMBINATION)
		
		if placed_tokens.has(cell_index):
			var difference_pos: Vector2 = Vector2.ZERO
			difference_pos = (initial_cell - cell_index) * Constants.CELL_SIZE
			var token : Token = placed_tokens[cell_index]
			token.set_in_range(difference_pos)



func get_tokens_of_type(type:Constants.TokenType) -> Dictionary:
	var filtered_tokens = {}
	for key in placed_tokens:
		if placed_tokens[key].type == type:
			filtered_tokens[key] = placed_tokens[key]
	return filtered_tokens
	
func get_tokens_with_id(id:String) -> Dictionary:
	var filtered_tokens = {}
	for key in placed_tokens:
		if placed_tokens[key].id == id:
			filtered_tokens[key] = placed_tokens[key]
	return filtered_tokens
