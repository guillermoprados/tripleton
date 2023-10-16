extends StateBase

class_name  StatePlayerTurn

signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)

@export var combinator: Combinator

var current_cell_index: Vector2

# for debugging purposes
@export var scroll_tokens:Array[TokenData] = []
var current_scroll_item: int = 0
var is_scroll_in_progress: bool = false

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.PLAYER
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

# override in states	
func _on_state_entered() -> void:
	
	combinator.reset_combinations(board.rows, board.columns)
	
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.PLAYING)
	
	game_manager.create_floating_token()
	
	game_manager.save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	game_manager.save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	game_manager.save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	board.enabled_interaction = true

# override in states
func _on_state_exited() -> void:
	
	game_manager.floating_token = null
	
	game_manager.save_token_cell.cell_entered.disconnect(self._on_save_token_cell_entered)
	game_manager.save_token_cell.cell_exited.disconnect(self._on_save_token_cell_exited)
	game_manager.save_token_cell.cell_selected.disconnect(self._on_save_token_cell_selected)
	
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
			var next_token_instance:Token = game_manager.instantiate_new_token(next_token_data, game_manager.floating_token.position, self)
			game_manager.floating_token.queue_free()
			game_manager.floating_token = next_token_instance
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			var combination:Combination = game_manager.check_recursive_combination(game_manager.floating_token, current_cell_index)
			if combination.is_valid():
				game_manager.highlight_combination(combination)
			is_scroll_in_progress = true
			var timer:SceneTreeTimer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout() -> void:
	is_scroll_in_progress = false
	
func _on_board_board_cell_moved(index:Vector2) -> void:
	current_cell_index = index
	game_manager.spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size:Vector2 = Constants.CELL_SIZE
	if board.is_cell_empty(index):
		var token_position:Vector2 = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		game_manager.floating_token.position = token_position
		var combination:Combination = game_manager.check_recursive_combination(game_manager.floating_token, current_cell_index)
		if combination.is_valid():
			game_manager.highlight_combination(combination)
		
func _on_board_board_cell_selected(index:Vector2) -> void:
	if board.is_cell_empty(index):
		game_manager.remove_child(game_manager.floating_token)
		game_manager.place_token_at_cell(game_manager.floating_token, index)
		finish_player_turn()
	else:
		var cell_token:Token = board.get_token_at_cell(index)
		if cell_token.type == Constants.TokenType.CHEST:
			game_manager.open_chest(cell_token, index)
		elif cell_token.type == Constants.TokenType.PRIZE:
			var prize_data: TokenPrizeData = cell_token.data
			show_rewards(prize_data.reward_type, prize_data.reward_value,index)
			game_manager.collect_reward(cell_token, index)
		else:
			show_message.emit("Cannot place token", Constants.MessageType.ERROR, .5); #localize

func finish_player_turn() -> void:
	state_finished.emit(id)
	
func _on_save_token_cell_entered(cell_index: Vector2) -> void:
	game_manager.save_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_index: Vector2) -> void:
	game_manager.save_token_cell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_index: Vector2) -> void:
	game_manager.swap_floating_token(cell_index)
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)	


func show_rewards(type:Constants.RewardType, value:int, cell_index:Vector2) -> void:
	
	var cell_position:Vector2 = board.get_cell_at_position(cell_index).position
	var reward_position: Vector2 = board.position + cell_position
	reward_position.x += Constants.CELL_SIZE.x / 2 
	reward_position.y += Constants.CELL_SIZE.y / 4 
		
	show_floating_reward.emit(type, value, reward_position)
