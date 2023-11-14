extends StateBase

class_name  StatePlayerTurn

@export var combinator: Combinator

# for debugging purposes
@export var scroll_tokens:Array[TokenData] = []
var current_scroll_item: int = 0
var is_scroll_in_progress: bool = false

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.PLAYER
	
# override in states	
func _on_state_entered() -> void:
	
	combinator.reset_combinations(board.rows, board.columns)
	
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
	
	game_manager.create_floating_token(null)
	
	game_manager.save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	game_manager.save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	game_manager.save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	board.board_cell_moved.connect(self._on_board_board_cell_moved)
	board.board_cell_selected.connect(self._on_board_board_cell_selected)
	
	board.enabled_interaction = true

func _process(delta) -> void:
	if not game_manager.floating_token:
		state_finished.emit(id)
		
# override in states
func _on_state_exited() -> void:
	
	assert(game_manager.floating_token == null, "The floating token is still around")
	
	game_manager.save_token_cell.cell_entered.disconnect(self._on_save_token_cell_entered)
	game_manager.save_token_cell.cell_exited.disconnect(self._on_save_token_cell_exited)
	game_manager.save_token_cell.cell_selected.disconnect(self._on_save_token_cell_selected)
	
	board.board_cell_moved.disconnect(self._on_board_board_cell_moved)
	board.board_cell_selected.disconnect(self._on_board_board_cell_selected)
	
	board.enabled_interaction = false
		
func _input(event:InputEvent) -> void:
	if !Constants.IS_DEBUG_MODE || is_scroll_in_progress:
		return

	if event is InputEventMouseButton:
		#this is only for debugging
		var next_token_data:TokenData = null
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_scroll_item += 1
			if current_scroll_item >= scroll_tokens.size():
				current_scroll_item = 0
			next_token_data = scroll_tokens[current_scroll_item]
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_scroll_item -= 1
			if current_scroll_item < 0:
				current_scroll_item = scroll_tokens.size() - 1
			next_token_data = scroll_tokens[current_scroll_item]
		if next_token_data != null:
			game_manager.discard_floating_token()
			game_manager.create_floating_token(next_token_data)
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			is_scroll_in_progress = true
			var timer:SceneTreeTimer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout() -> void:
	is_scroll_in_progress = false
	
func _on_board_board_cell_moved(index:Vector2) -> void:
	# I need this line because there is non sense on having other linked events 
	game_manager.spawn_token_cell.clear_highlight()
	board.clear_highlights()
	game_manager.move_floating_token_to_cell(index)	
	
func _on_board_board_cell_selected(index:Vector2) -> void:
	game_manager.try_to_place_floating_token(index)
	
func _on_save_token_cell_entered(cell_index: Vector2) -> void:
	game_manager.move_floating_token_to_swap_cell()
	game_manager.save_token_cell.set_highlight(Constants.CellHighlight.VALID)
	
func _on_save_token_cell_exited(cell_index: Vector2) -> void:
	game_manager.save_token_cell.set_highlight(Constants.CellHighlight.NONE)
	
func _on_save_token_cell_selected(cell_index: Vector2) -> void:
	game_manager.swap_floating_and_saved_token(cell_index)
