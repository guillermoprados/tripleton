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
	
	if not game_manager.initial_token_slot.token:
		game_manager.spawn_new_token(null)
	
	for save_slot in game_manager.save_slots:
		save_slot.on_slot_entered.connect(game_manager.on_save_token_slot_entered)
		save_slot.on_slot_selected.connect(game_manager.on_save_token_slot_selected)
		save_slot.enabled = true
		
	
	board.board_cell_moved.connect(self._on_board_board_cell_moved)
	board.board_cell_selected.connect(self._on_board_board_cell_selected)
	
	board.enabled_interaction = true

func _process(delta:float) -> void:
	if not game_manager.floating_token and not game_manager.initial_token_slot.token:
		game_manager.check_enclosed_enemies_and_kill_them()
		state_finished.emit(id)
		
# override in states
func _on_state_exited() -> void:
	
	assert(game_manager.floating_token == null, "The floating token is still around")
	
	board.board_cell_moved.disconnect(self._on_board_board_cell_moved)
	board.board_cell_selected.disconnect(self._on_board_board_cell_selected)
	
	for save_slot in game_manager.save_slots:
		save_slot.on_slot_entered.disconnect(game_manager.on_save_token_slot_entered)
		save_slot.on_slot_selected.disconnect(game_manager.on_save_token_slot_selected)
		save_slot.enabled = false
	
	#so the user can see it	
	game_manager.spawn_new_token(null)
	
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
			
			if game_manager.floating_token:
				game_manager.discard_floating_token()
			if game_manager.initial_token_slot.token:
				game_manager.initial_token_slot.discard_token()
				
			game_manager.spawn_new_token(next_token_data)
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			is_scroll_in_progress = true
			var timer:SceneTreeTimer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout() -> void:
	is_scroll_in_progress = false
	
func _on_board_board_cell_moved(index:Vector2) -> void:
	
	if not game_manager.floating_token:
		game_manager.pick_up_floating_token()
	
	board.clear_highlights()
	game_manager.move_floating_token_to_cell(index)	
	
func _on_board_board_cell_selected(index:Vector2) -> void:
	
	if not game_manager.floating_token:
		game_manager.pick_up_floating_token()
	
	game_manager.process_cell_selection(index)
	
func _on_save_token_cell_entered(cell_index: Vector2) -> void:
	game_manager.move_floating_token_to_swap_cell()
	game_manager.save_token_cell.set_highlight(Constants.CellHighlight.VALID)
	
func _on_save_token_cell_exited(cell_index: Vector2) -> void:
	game_manager.save_token_cell.set_highlight(Constants.CellHighlight.NONE)
	
func _on_save_token_cell_selected(cell_index: Vector2) -> void:
	game_manager.swap_floating_and_saved_token(cell_index)
