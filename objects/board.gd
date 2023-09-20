extends Node2D

@export var levelConfig: Resource

@export var cell_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if levelConfig:
		createBoard(levelConfig.rows, levelConfig.columns)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func createBoard(rows: int, columns: int):
	for row in range(rows):
		for col in range(columns):
			var cell_instance = cell_scene.instantiate()
			var cell_size:Vector2 = cell_instance.size()
			cell_instance.position = Vector2(col * cell_size.x, row * cell_size.y)
			cell_instance.cell_index = Vector2(row, col)
			# Add the cell instance as a child of the board scene
			add_child(cell_instance)

			# You can perform any additional initialization or configuration of the cell instance here

			# Optionally, store a reference to the cell instance if needed
			# cell_instances[row][col] = cell_instance

# Assuming you have cell_width and cell_height defined somewhere

