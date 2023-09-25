extends Node2D

@export var token_provider: TokenProvider
@export var level_config: LevelConfig

var floating_token

signal show_message(message:String, theme_color:String, time:float)

func _ready():
	assert(token_provider, "token_provider is not set!")
	assert(level_config, "level_config is not set!")
	$Board.initialize(level_config)
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
	if floating_token:
		floating_token.position = $Board.position
	$Board.clear_current_hovering()

func create_floating_token():
	var token_instance = token_provider.get_token_instance()
	var cell_size = $Board.cell_size
	add_child(token_instance)
	token_instance.set_size(cell_size)
	token_instance.position = $SpawnTokenCell.position
	$SpawnTokenCell.highlight(Constants.HighlightMode.HOVER, true)
	floating_token = token_instance

func _on_board_board_cell_moved(index):
	$SpawnTokenCell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size = $Board.cell_size
	var token_position = $Board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
	floating_token.position = token_position

func _on_board_board_cell_selected(index):
	if $Board.is_cell_empty(index):
		remove_child(floating_token)
		$Board.set_token_at_cell(floating_token, index)
		$Board.clear_current_hovering()
		create_floating_token()
	else:
		show_message.emit("Cannot place token", "error_font", .5); #localize
