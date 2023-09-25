extends Node2D

var floating_token: Token
var saved_token: Token

signal show_message(message:String, theme_color:String, time:float)

func _ready():
	$Board.initialize($TokenInstanceProvider.level_config)
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	create_floating_token()
	$SaveTokenCell.cell_entered.connect(self._on_save_token_cell_entered)
	$SaveTokenCell.cell_exited.connect(self._on_save_token_cell_exited)
	$SaveTokenCell.cell_selected.connect(self._on_save_token_cell_selected)
	
	
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
	var token_instance = $TokenInstanceProvider.get_token_instance()
	var cell_size = $Board.cell_size
	add_child(token_instance)
	token_instance.set_size(cell_size)
	token_instance.position = $SpawnTokenCell.position
	$SpawnTokenCell.highlight(Constants.HighlightMode.HOVER, true)
	floating_token = token_instance

func _on_board_board_cell_moved(index):
	$SpawnTokenCell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size = $Board.cell_size
	if $Board.is_cell_empty(index):
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

func _on_save_token_cell_entered(cell_pos: Vector2):
	$SaveTokenCell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_pos: Vector2):
	$SaveTokenCell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_pos: Vector2):
	if saved_token:
		var floating_pos = floating_token.position
		var switch_token = floating_token
		floating_token = saved_token
		saved_token = switch_token
		floating_token.position = floating_pos
		saved_token.position = $SaveTokenCell.position
	else:
		print("no saved token")
		floating_token.position = $SaveTokenCell.position
		saved_token = floating_token 
		create_floating_token()
