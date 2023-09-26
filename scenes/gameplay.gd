extends Node2D

var floating_token: Token
var saved_token: Token

signal show_message(message:String, theme_color:String, time:float)

var board:Board
var token_instance_provider:TokenInstanceProvider
var save_token_cell: BoardCell
var spawn_token_cell: BoardCell

func _ready():
	
	board = $Board
	token_instance_provider = $TokenInstanceProvider
	save_token_cell = $SaveTokenCell
	spawn_token_cell = $SpawnTokenCell
	
	board.initialize(token_instance_provider.level_config)
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	create_floating_token()
	save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
func _on_screen_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	$ColorRect.set_size(screen_size)
	var board_size = board.board_size
	var board_pos = Vector2(
		(screen_size.x - board_size.x) / 2,
		(screen_size.y - board_size.y) / 2
	)
	board.position = board_pos
	if floating_token:
		floating_token.position = board.position
	board.clear_current_hovering()

func create_floating_token():
	var token_instance = token_instance_provider.get_token_instance()
	var cell_size = board.cell_size
	add_child(token_instance)
	token_instance.set_size(cell_size)
	token_instance.position = spawn_token_cell.position
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	floating_token = token_instance

func _on_board_board_cell_moved(index):
	spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size = board.cell_size
	if board.is_cell_empty(index):
		var token_position = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		floating_token.position = token_position

func _on_board_board_cell_selected(index):
	if board.is_cell_empty(index):
		remove_child(floating_token)
		board.set_token_at_cell(floating_token, index)
		board.clear_current_hovering()
		create_floating_token()
	else:
		show_message.emit("Cannot place token", "error_font", .5); #localize

func _on_save_token_cell_entered(cell_pos: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_pos: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_pos: Vector2):
	if saved_token:
		var floating_pos = floating_token.position
		var switch_token = floating_token
		floating_token = saved_token
		saved_token = switch_token
		floating_token.position = floating_pos
		saved_token.position = save_token_cell.position
	else:
		print("no saved token")
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		create_floating_token()
