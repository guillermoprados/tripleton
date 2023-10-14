extends StateBase

class_name  StatePlayerTurn

signal show_message(message:String, type:Constants.MessageType, time:float)
signal show_floating_reward(type:Constants.RewardType, value:int, position:Vector2)

@export var combinator: Combinator
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell

var current_cell_index: Vector2

# for debugging purposes
@export var scroll_tokens:Array[TokenData] = []
var current_scroll_item: int = 0
var is_scroll_in_progress: bool = false

var floating_token: Token
var saved_token: Token

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
	
	create_floating_token()
	
	save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	board.enabled_interaction = true

# override in states
func _on_state_exited() -> void:
	
	floating_token = null
	
	save_token_cell.cell_entered.disconnect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.disconnect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.disconnect(self._on_save_token_cell_selected)
	
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
			var next_token_instance:Token = game_manager.instantiate_new_token(next_token_data, floating_token.position, self)
			floating_token.queue_free()
			floating_token = next_token_instance
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			var combination:Combination = check_recursive_combination(floating_token, current_cell_index)
			if combination.is_valid():
				highlight_combination(combination)
			is_scroll_in_progress = true
			var timer:SceneTreeTimer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout() -> void:
	is_scroll_in_progress = false

func create_floating_token() -> void:
	var random_token_data:TokenData = game_manager.get_random_token_data()
	floating_token = game_manager.instantiate_new_token(random_token_data, spawn_token_cell.position, self)
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	
func _on_board_board_cell_moved(index:Vector2) -> void:
	current_cell_index = index
	spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var cell_size:Vector2 = Constants.CELL_SIZE
	if board.is_cell_empty(index):
		var token_position:Vector2 = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		floating_token.position = token_position
		var combination:Combination = check_recursive_combination(floating_token, current_cell_index)
		if combination.is_valid():
			highlight_combination(combination)
		
func _on_board_board_cell_selected(index:Vector2) -> void:
	
	if board.is_cell_empty(index):
		remove_child(floating_token)
		place_token_at_cell(floating_token, index)
		finish_player_turn()
	else:
		var cell_token:Token = board.get_token_at_cell(index)
		if cell_token.type == Constants.TokenType.CHEST:
			open_chest(cell_token, index)
		elif cell_token.type == Constants.TokenType.PRIZE:
			collect_reward(cell_token, index)
		else:
			show_message.emit("Cannot place token", Constants.MessageType.ERROR, .5); #localize

func finish_player_turn() -> void:
	state_finished.emit(id)
	
func open_chest(token:Token, cell_index: Vector2) -> void:
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	#remove the chest
	board.clear_token(cell_index)
	
	var chest_data: TokenChestData = token.data
	var prize_data:TokenPrizeData = chest_data.get_random_prize()
	var prize_instance:Token = game_manager.instantiate_new_token(prize_data, Vector2.ZERO, null)
	place_token_at_cell(prize_instance, cell_index)
	
func collect_reward(token:Token, cell_index: Vector2) -> void:
	var prize_data: TokenPrizeData = token.data
	show_rewards(prize_data.reward_type, prize_data.reward_value,cell_index)
	sum_rewards(prize_data.reward_type, prize_data.reward_value)
	board.clear_token(cell_index)	

func _on_save_token_cell_entered(cell_index: Vector2) -> void:
	save_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_index: Vector2) -> void:
	save_token_cell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_index: Vector2) -> void:
	__swap_floating_token(cell_index)

func __swap_floating_token(cell_index: Vector2) -> void:
	if saved_token:
		var floating_pos:Vector2 = floating_token.position
		var switch_token:Token = floating_token
		floating_token = saved_token
		saved_token = switch_token
		floating_token.position = floating_pos
		saved_token.position = save_token_cell.position
	else:
		floating_token.position = save_token_cell.position
		saved_token = floating_token 
		create_floating_token()
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)

func place_token_at_cell(token:Token, cell_index: Vector2) -> void:
	
	if token.type == Constants.TokenType.WILDCARD:
		#I need to replace the token
		var combination : Combination = combinator.get_combinations_for_cell(cell_index)
		if combination.is_valid():
			token = board.get_token_at_cell(combination.combinable_cells[1]) # skip the first one
		else: 
			var next_token_data: TokenData = token.data.next_token
			token = game_manager.instantiate_new_token(next_token_data, floating_token.position, null)
			floating_token.queue_free()

	assert(token, "trying to set a null token")
	combinator.reset_combinations(board.rows, board.columns)
	board.set_token_at_cell(token, cell_index)
	assert(board.get_token_at_cell(cell_index), "placed token is empty")
	board.clear_highlights()
	var combination:Combination = check_single_combination(token, cell_index)
	if combination.is_valid():
		var combined_token:Token = combine_tokens(combination)
		place_token_at_cell(combined_token, combination.cell_index)
	
func check_recursive_combination(token:Token, cell_index:Vector2) -> Combination:
	if token.type == Constants.TokenType.WILDCARD:
		__check_wildcard_combination_at(cell_index)
	
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, true)

func check_single_combination(token:Token, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(token.data, cell_index, board.cell_tokens_ids, false)

func highlight_combination(combination:Combination) -> void:
	for cell_index in combination.combinable_cells:
		board.get_cell_at_position(cell_index).highlight(Constants.HighlightMode.COMBINATION, true)
		
func combine_tokens(combination: Combination) -> Token:
	
	var initial_token:Token = board.get_token_at_cell(combination.initial_cell())
	var initial_token_data:TokenCombinableData = initial_token.data
	
	var next_token_data:TokenCombinableData = initial_token_data.next_token
	
	for i in range(combination.last_level_reached):
		next_token_data = next_token_data.next_token
		
	var combined_token : Token = game_manager.instantiate_new_token(next_token_data, Vector2.ZERO, null)

	var awarded_points:int = 0	
	for cell_index in combination.combinable_cells:
		var token:Token = board.get_token_at_cell(cell_index)
		if token.data.reward_type == Constants.RewardType.GOLD:
			assert("Please do not reward with gold in combinations")
			# awarded_gold += token.data.reward_value
		elif token.data.reward_type == Constants.RewardType.POINTS:
			awarded_points += token.data.reward_value
			show_rewards(token.data.reward_type, token.data.reward_value, cell_index)
		board.clear_token(cell_index)
	
	if awarded_points > 0:
		sum_rewards(Constants.RewardType.POINTS, awarded_points)
		
	return combined_token

func show_rewards(type:Constants.RewardType, value:int, cell_index:Vector2) -> void:
	
	var cell_position:Vector2 = board.get_cell_at_position(cell_index).position
	var reward_position: Vector2 = board.position + cell_position
	reward_position.x += Constants.CELL_SIZE.x / 2 
	reward_position.y += Constants.CELL_SIZE.y / 4 
		
	show_floating_reward.emit(type, value, reward_position)

func sum_rewards(type:Constants.RewardType, value:int) -> void:
	if type == Constants.RewardType.GOLD:
		game_manager.add_gold(value)
	elif type == Constants.RewardType.POINTS:
		game_manager.add_points(value)
	else:
		assert( false, "what are you trying to add??")	

func __check_wildcard_combination_at(cell_index:Vector2) -> void:
	
	var bigger_combination: Combination = null
	var bigger_points:int
	
	var check_positions:Array[Vector2] = []
	
	# top
	if cell_index.y > 0:
		check_positions.append(Vector2(cell_index.x, cell_index.y - 1))
	# down
	if cell_index.y < board.rows - 1:
		check_positions.append(Vector2(cell_index.x, cell_index.y + 1))
	# left
	if cell_index.x > 0:
		check_positions.append(Vector2(cell_index.x - 1, cell_index.y))
	# right
	if cell_index.x < board.rows - 1:
		check_positions.append(Vector2(cell_index.x + 1, cell_index.y))
	
	for pos in check_positions:
		
		if board.is_cell_empty(pos):
			continue
					
		var copied_token = board.get_token_at_cell(pos)
		
		# this will never happen because it requires two wildcards in the board
		# .. but anyway..
		if copied_token.type == Constants.TokenType.WILDCARD:
			continue
		
		combinator.clear_evaluated_combination(cell_index)
		
		var combination : Combination = check_recursive_combination(copied_token, cell_index)
			
		if combination.is_valid():
			var current_points:int = 0
			
			for cell in combination.combinable_cells:
				if board.is_cell_empty(cell):
					continue
				var token:Token = board.get_token_at_cell(cell)
				if token.data.reward_type == Constants.RewardType.POINTS:
					current_points += token.data.reward_value
			if current_points > bigger_points:
				bigger_combination = combination

	if bigger_combination:
		combinator.replace_combination_at_cell(bigger_combination, cell_index)

	
