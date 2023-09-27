extends Node2D

var floating_token: Token
var saved_token: Token

signal show_message(message:String, theme_color:String, time:float)

var board:Board
var token_instance_provider:TokenInstanceProvider
var token_data_provider:TokenDataProvider
var save_token_cell: BoardCell
var spawn_token_cell: BoardCell
var combinator: Combinator

# for debugging purposes
var is_scroll_in_progress: bool = false
var current_cell_index: Vector2

func _ready():
	board = $Board
	token_instance_provider = $TokenInstanceProvider
	token_data_provider = $TokenDataProvider
	save_token_cell = $SaveTokenCell
	spawn_token_cell = $SpawnTokenCell
	combinator = $Combinator
	
	save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	combinator.reset_combinations(board.rows, board.columns)
	
	create_floating_token()
	
	# Connect the screen size changed signal to a function
	get_tree().root.size_changed.connect(_on_screen_size_changed)
	_on_screen_size_changed()
	
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
	board.clear_highlights()

func _input(event):
	if !Constants.IS_DEBUG_MODE || is_scroll_in_progress:
		return

	if event is InputEventMouseButton:
		#this is only for debugging
		var next_token_data = null
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if token_data_provider.token_has_next_level(floating_token.id):
				next_token_data = token_data_provider.get_next_level_data(floating_token.id)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if token_data_provider.token_has_previous_level(floating_token.id):
				next_token_data = token_data_provider.get_previous_level_data(floating_token.id)
		if next_token_data != null:
			var next_token_instance = token_instance_provider.get_token_instance(next_token_data)
			add_child(next_token_instance)
			next_token_instance.set_size(board.cell_size)
			next_token_instance.position = floating_token.position
			floating_token.queue_free()
			floating_token = next_token_instance
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			var combination:Combination = check_combination(current_cell_index, floating_token.id)
			if combination.is_valid():
				highlight_combination(combination)
			is_scroll_in_progress = true
			var timer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)
			
func __on_scroll_timer_timeout():
	is_scroll_in_progress = false

func create_floating_token():
	var token_instance = token_instance_provider.get_random_token_instance()
	add_child(token_instance)
	token_instance.set_size(board.cell_size)
	token_instance.position = spawn_token_cell.position
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	floating_token = token_instance

func _on_board_board_cell_moved(index):
	current_cell_index = index
	spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size = board.cell_size
	if board.is_cell_empty(index):
		var token_position = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		floating_token.position = token_position
		var combination:Combination = check_combination(index, floating_token.id)
		if combination.is_valid():
			highlight_combination(combination)
		
func _on_board_board_cell_selected(index):
	if board.is_cell_empty(index):
		remove_child(floating_token)
		board.set_token_at_cell(floating_token, index)
		board.clear_highlights()
		var combination:Combination = check_combination(index, floating_token.id)
		if combination.is_valid():
			combine_tokens(combination)
		combinator.reset_combinations(board.rows, board.columns)
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
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		create_floating_token()

func check_combination(cell_index:Vector2, tokenId) -> Combination:
	return combinator.search_combinations_for_cell(tokenId, cell_index, board.cell_tokens_ids)

func highlight_combination(combination:Combination):
	for cell_index in combination.combinable_cells:
		board.get_cell_at_position(cell_index).highlight(Constants.HighlightMode.COMBINATION, true)
		
func combine_tokens(combination: Combination):
	for cell_index in combination.combinable_cells:
		var token_id = board.get_token_id_at_cell(cell_index)
		board.clear_token(cell_index)

		# Add the combination result
		if cell_index == combination.initial_cell():
			var next_token_data:TokenData
			if token_data_provider.token_has_next_level(token_id):
				next_token_data = token_data_provider.get_next_level_data(token_id)
			else:
				next_token_data = token_data_provider.get_prize_for_token_category(token_id)
			var next_token_instance = token_instance_provider.get_token_instance(next_token_data)
			next_token_instance.set_size(board.cell_size)
			board.set_token_at_cell(next_token_instance,cell_index)
