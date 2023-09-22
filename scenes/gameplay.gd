extends Node2D

@export var token_scene: PackedScene

func _ready():
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	create_floating_token()

func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	$ColorRect.set_size(screen_size)
	var board_size = $Board.size
	var board_pos = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	$Board.position = board_pos

func create_floating_token():
	var token_instance = token_scene.instantiate()
		# cell_size = cell_instance.size()
		# cell_instance.position = Vector2(col * cell_size.x, row * cell_size.y)
		# cell_instance.cell_index = Vector2(row, col)
		# Add the cell instance as a child of the board scene
	add_child(token_instance)
