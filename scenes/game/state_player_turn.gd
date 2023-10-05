extends StateBase

class_name  StatePlayerTurn

@export var combinator: Combinator
@export var save_token_cell: BoardCell
@export var spawn_token_cell: BoardCell

var current_cell_index: Vector2

# for debugging purposes
var is_scroll_in_progress: bool = false

var floating_token: Token
var saved_token: Token

# Called when the node enters the scene tree for the first time.
func _ready():
	save_token_cell.cell_entered.connect(self._on_save_token_cell_entered)
	save_token_cell.cell_exited.connect(self._on_save_token_cell_exited)
	save_token_cell.cell_selected.connect(self._on_save_token_cell_selected)
	
	combinator.reset_combinations(board.rows, board.columns)
	
	create_floating_token()
	
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
			if game_manager.token_data_provider.token_has_next_level(floating_token.id):
				next_token_data = game_manager.token_data_provider.get_next_level_data(floating_token.id)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if game_manager.token_data_provider.token_has_previous_level(floating_token.id):
				next_token_data = game_manager.token_data_provider.get_previous_level_data(floating_token.id)
		if next_token_data != null:
			var next_token_instance = game_manager.instantiate_new_token(next_token_data, floating_token.position, self)
			floating_token.queue_free()
			floating_token = next_token_instance
			combinator.reset_combinations(board.rows, board.columns)
			board.clear_highlights()
			var combination:Combination = check_recursive_combination(floating_token.id, current_cell_index)
			if combination.is_valid():
				highlight_combination(combination)
			is_scroll_in_progress = true
			var timer = get_tree().create_timer(0.1)
			timer.connect("timeout", self.__on_scroll_timer_timeout)

func __on_scroll_timer_timeout():
	is_scroll_in_progress = false

func create_floating_token():
	var random_token_data = token_instance_provider.get_random_token_data()
	floating_token = game_manager.instantiate_new_token(random_token_data, spawn_token_cell.position, self)
	spawn_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	
func _on_board_board_cell_moved(index:Vector2):
	current_cell_index = index
	spawn_token_cell.highlight(Constants.HighlightMode.NONE, true)
	var board = board
	var cell_size = board.cell_size
	if board.is_cell_empty(index):
		var token_position = board.position + Vector2(index.y * cell_size.x, index.x * cell_size.y)
		floating_token.position = token_position
		var combination:Combination = check_recursive_combination(floating_token.id, current_cell_index)
		if combination.is_valid():
			highlight_combination(combination)
		
func _on_board_board_cell_selected(index:Vector2):
	var board = board
	
	if board.is_cell_empty(index):
		remove_child(floating_token)
		place_token_at_cell(floating_token, index)
		create_floating_token()
	else:
		var cell_token:Token = board.get_token_at_cell(index)
		if game_manager.token_data_provider.token_is_chest(cell_token.id):
			open_chest(cell_token, index)
		elif game_manager.token_data_provider.token_is_prize(cell_token.id):
			collect_reward(cell_token, index)
		else:
			game_manager.show_game_message("Cannot place token", Constants.MessageType.ERROR, .5); #localize

func open_chest(token:Token, cell_index: Vector2):
	#move the floating token back
	floating_token.position = spawn_token_cell.position
	#remove the chest
	board.clear_token(cell_index)
	
	var chest: TokenChest = game_manager.token_data_provider.get_chest(token.id)
	var prize_data: TokenData = chest.get_random_prize()
	var prize_instance = game_manager.instantiate_new_token(prize_data, Vector2.ZERO, null)
	place_token_at_cell(prize_instance, cell_index)
	
func collect_reward(token:Token, cell_index: Vector2):
	var prize: TokenData = game_manager.token_data_provider.token_data_by_token_id[token.id]
	game_manager.sum_rewards(prize.reward_type, prize.reward_value, cell_index)
	board.clear_token(cell_index)	

func _on_save_token_cell_entered(cell_index: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.HOVER, true)
	pass
	
func _on_save_token_cell_exited(cell_index: Vector2):
	save_token_cell.highlight(Constants.HighlightMode.NONE, true)
	pass
	
func _on_save_token_cell_selected(cell_index: Vector2):
	__swap_floating_token(cell_index)

func __swap_floating_token(cell_index: Vector2):
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
	# reset combinations because we're caching them
	combinator.reset_combinations(board.rows, board.columns)



func place_token_at_cell(token:Token, cell_index: Vector2):
	assert(token, "trying to set a null token")
	combinator.reset_combinations(board.rows, board.columns)
	board.set_token_at_cell(token, cell_index)
	assert(board.get_token_at_cell(cell_index), "placed token is empty")
	board.clear_highlights()
	var combination:Combination = check_single_combination(token.id, cell_index)
	if combination.is_valid():
		var combined_token = combine_tokens(combination)
		place_token_at_cell(combined_token, combination.cell_index)
	
func check_recursive_combination(tokenId, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(tokenId, cell_index, board.cell_tokens_ids, true, game_manager.token_data_provider)

func check_single_combination(tokenId, cell_index:Vector2) -> Combination:
	return combinator.search_combinations_for_cell(tokenId, cell_index, board.cell_tokens_ids, false, game_manager.token_data_provider)

func highlight_combination(combination:Combination):
	for cell_index in combination.combinable_cells:
		board.get_cell_at_position(cell_index).highlight(Constants.HighlightMode.COMBINATION, true)
		
func combine_tokens(combination: Combination) -> Token:
	
	var base_token_id:String = board.get_token_at_cell(combination.initial_cell()).id
	var token_data_provider = game_manager.token_data_provider
	
	var next_token_data:TokenData
	if token_data_provider.token_has_next_level(base_token_id):
		next_token_data = token_data_provider.get_next_level_data(base_token_id)
	else:
		next_token_data = token_data_provider.get_prize_for_token_combination(base_token_id)
	
	var combined_token : Token = game_manager.instantiate_new_token(next_token_data, Vector2.ZERO, null)
	
	for cell_index in combination.combinable_cells:
		var token_id:String = board.get_token_at_cell(cell_index).id
		var token_data: TokenData = token_data_provider.token_data_by_token_id[token_id]
		
		game_manager.sum_rewards(token_data.reward_type, token_data.reward_value, cell_index)
		board.clear_token(cell_index)
					
	return combined_token
