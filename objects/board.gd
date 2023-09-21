extends Node2D

@export var levelConfig: Resource

@export var cell_scene: PackedScene

var size : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	if levelConfig:
		createBoard(levelConfig.rows, levelConfig.columns)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func createBoard(rows: int, columns: int):
	var cell_size:Vector2
	for row in range(rows):
		for col in range(columns):
			var cell_instance = cell_scene.instantiate()
			cell_size = cell_instance.size()
			cell_instance.position = Vector2(col * cell_size.x, row * cell_size.y)
			cell_instance.cell_index = Vector2(row, col)
			# Add the cell instance as a child of the board scene
			add_child(cell_instance)
	size = Vector2(columns * cell_size.x, rows * cell_size.y)

