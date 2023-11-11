extends TokenAction

class_name ActionWildcard

@export var combinator: Combinator
@export var tokens_data: Array[TokenData]
@export var ghost_token_holder: Node2D

var __combinator_configured: bool = false
var __last_position_evaluated: Vector2 = Constants.INVALID_CELL
var __to_place_token_data: TokenData
var __to_place_token:Token

func get_type() -> Constants.ActionType:
	return Constants.ActionType.WILDCARD

func get_to_place_token_data() -> TokenData:
	return __to_place_token_data

func set_ghost_token(token:Token) -> void:
	__to_place_token = token
	ghost_token_holder.add_child(token)
	token.position = __token.sprite_holder.sprite_original_position

func get_wildcard_combination() -> Combination:
	return combinator.combinations[__last_position_evaluated]

func __check_and_init_combinator(cell_origin:Vector2, board_ids: Array)-> void:
	if cell_origin != __last_position_evaluated or not __combinator_configured:
		combinator.reset_combinations(board_ids.size(),board_ids[0].size())
		__combinator_configured = true
		__last_position_evaluated = cell_origin
		__to_place_token_data = null
		if __to_place_token:
			ghost_token_holder.remove_child(__to_place_token)
			__to_place_token.queue_free()
			__to_place_token = null

func action_status_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	
	__check_and_init_combinator(action_cell, cell_tokens_ids)
	
	var result:Constants.ActionResult = Constants.ActionResult.NOT_VALID
	
	if not __is_cell_empty(action_cell, cell_tokens_ids):
		result = Constants.ActionResult.NOT_VALID
	else:
		
		__mark_wildcard_combinations_at(action_cell, cell_tokens_ids)
		
		var combination:Combination = combinator.search_combinations_for_cell(__token.data, action_cell, cell_tokens_ids, true)

		if combination.is_valid():
			result = Constants.ActionResult.VALID
		else:
			result = Constants.ActionResult.WASTED
	
	return result 
		
func affected_cells(action_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	
	__check_and_init_combinator(action_cell, cell_tokens_ids)
	
	__mark_wildcard_combinations_at(action_cell, cell_tokens_ids)
	
	var cells : Array[Vector2]	= []
	var combination:Combination = combinator.search_combinations_for_cell(__token.data, action_cell, cell_tokens_ids, true)

	for cell in combination.combinable_cells:
		cells.append(cell)
	
	return cells

func __find_token_by_id(token_id:String) -> TokenData:
	for data in tokens_data:
		if data.id == token_id:
			return data
	return null
	
func __mark_wildcard_combinations_at(cell_index:Vector2, cell_tokens_ids: Array) -> void:
	
	if combinator.get_combinations_for_cell(cell_index).wildcard_evaluated:
		return
	
	var bigger_combination: Combination = null
	var bigger_combination_token_data: TokenData = null
	var bigger_points:int
	
	var check_positions:Array[Vector2] = []
	
	# top
	if cell_index.y > 0:
		check_positions.append(Vector2(cell_index.x, cell_index.y - 1))
	# down
	if cell_index.y < cell_tokens_ids.size() - 1:
		check_positions.append(Vector2(cell_index.x, cell_index.y + 1))
	# left
	if cell_index.x > 0:
		check_positions.append(Vector2(cell_index.x - 1, cell_index.y))
	# right
	if cell_index.x < cell_tokens_ids[0].size() - 1:
		check_positions.append(Vector2(cell_index.x + 1, cell_index.y))
	
	for pos in check_positions:
		
		if __is_cell_empty(pos, cell_tokens_ids):
			continue
					
		var copied_token_data = __find_token_by_id(cell_tokens_ids[pos.x][pos.y])
		
		# only assigned tokens to the action can be evaluated
		if not copied_token_data:
			continue
		
		var board_tokens_ids_copy : Array = Utils.copy_array_matrix(cell_tokens_ids)
		
		# set the token type in the board temporarily 
		board_tokens_ids_copy[cell_index.x][cell_index.y] = copied_token_data.id
		
		combinator.clear_evaluated_combination(cell_index)
		
		var combination : Combination = combinator.search_combinations_for_cell(copied_token_data, pos, board_tokens_ids_copy, true)
		
		if combination.is_valid():
			var current_points:int = 0
			for cell in combination.combinable_cells:
				if __is_cell_empty(cell, board_tokens_ids_copy):
					continue
				var token_data:TokenData = __find_token_by_id(board_tokens_ids_copy[cell.x][cell.y])
				if token_data.reward_type == Constants.RewardType.POINTS:
					current_points += token_data.reward_value
			
			if current_points > bigger_points:
				bigger_points = current_points
				bigger_combination = combination
				bigger_combination_token_data = __find_token_by_id(board_tokens_ids_copy[cell_index.x][cell_index.y])
				
	if bigger_combination:
		combinator.replace_combination_at_cell(bigger_combination, cell_index)
		__to_place_token_data = bigger_combination_token_data
		
	combinator.get_combinations_for_cell(cell_index).wildcard_evaluated = true
