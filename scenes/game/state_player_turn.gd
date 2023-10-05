extends StateBase

class_name  StatePlayerTurn

# for debugging purposes
var is_scroll_in_progress: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if !Constants.IS_DEBUG_MODE || is_scroll_in_progress:
		return

	if event is InputEventMouseButton:
		#this is only for debugging
		var next_token_data = null
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if game_manager.token_data_provider.token_has_next_level(game_manager.floating_token.id):
				next_token_data = game_manager.token_data_provider.get_next_level_data(game_manager.floating_token.id)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if game_manager.token_data_provider.token_has_previous_level(game_manager.floating_token.id):
				next_token_data = game_manager.token_data_provider.get_previous_level_data(game_manager.floating_token.id)
		if next_token_data != null:
			var next_token_instance = game_manager.__instantiate_token(game_manager.next_token_data, game_manager.floating_token.position, self)
			game_manager.floating_token.queue_free()
			game_manager.floating_token = next_token_instance
			game_manager.combinator.reset_combinations(game_manager.board.rows, game_manager.board.columns)
			game_manager.board.clear_highlights()
			var combination:Combination = game_manager.__check_recursive_combination(game_manager.floating_token.id, game_manager.current_cell_index)
			if combination.is_valid():
				game_manager.__highlight_combination(combination)
			is_scroll_in_progress = true
			var timer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout():
	is_scroll_in_progress = false
