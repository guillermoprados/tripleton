extends Node2D

@export var token_scene: PackedScene

var floating_token
var placed_tokens = []

func _ready():
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	create_floating_token()

func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	$ColorRect.set_size(screen_size)
	var board_size = $Board.board_size
	var board_pos = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	$Board.position = board_pos

func create_floating_token():
	var token_instance = token_scene.instantiate()
	var closer_empty_cell = $Board.get_closer_empty_cell_to_last_token()
	var cell_size = $Board.cell_size
	add_child(token_instance)
	var token_position = $Board.position + Vector2(closer_empty_cell.x * cell_size.x, closer_empty_cell.y * cell_size.y)
	token_instance.set_size(cell_size)
	token_instance.position = token_position
	floating_token = token_instance


func _on_board_board_cell_moved(index):
	var cell_size = $Board.cell_size
	var token_position = $Board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
	floating_token.position = token_position

func _on_board_board_cell_selected(index):
	if $Board.is_cell_empty(index):
		placed_tokens.append(floating_token)
		create_floating_token()
