extends TokenAction

class_name ActionWildcard

@export var combinator: Combinator
@export var ghost_token_holder: Node2D

var __combinator_configured: bool = false
var __last_position_evaluated: Vector2 = Constants.INVALID_CELL
var __to_place_token_data: TokenData
var __to_place_token:BoardToken

func get_type() -> Constants.ActionType:
	return Constants.ActionType.WILDCARD

func get_to_place_token_data() -> TokenData:
	return __to_place_token_data

func set_ghost_token(token:BoardToken) -> void:
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

func action_check_result_on_cell(action_cell:Vector2, cell_tokens_ids: Array) -> Constants.ActionResult:
	
	__check_and_init_combinator(action_cell, cell_tokens_ids)
	
	var result:Constants.ActionResult = Constants.ActionResult.INVALID
	
	if not __is_cell_empty(action_cell, cell_tokens_ids):
		result = Constants.ActionResult.INVALID
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

func __mark_wildcard_combinations_at(cell_index:Vector2, cell_tokens_ids: Array) -> void:
	
	if combinator.get_combinations_for_cell(cell_index).wildcard_evaluated:
		return
	
	var bigger_combination: Combination = null
	var bigger_combination_token_data: TokenData = null
	var bigger_points:int = 0
	
	var check_positions:Array[Vector2] = []
	
	var board_rows:int = cell_tokens_ids.size()
	var board_columns:int = cell_tokens_ids[0].size()
	
	# top
	if cell_index.x > 0:
		check_positions.append(Vector2(cell_index.x - 1, cell_index.y))
	# down
	if cell_index.x < board_rows - 1:
		check_positions.append(Vector2(cell_index.x + 1, cell_index.y))
	# left
	if cell_index.y > 0:
		check_positions.append(Vector2(cell_index.x, cell_index.y - 1))
	# right
	if cell_index.y < board_columns - 1:
		check_positions.append(Vector2(cell_index.x, cell_index.y + 1))
	
	for pos in check_positions:
		
		if __is_cell_empty(pos, cell_tokens_ids):
			continue
					
		var copied_token_data := __token.get_other_token_data_util(cell_tokens_ids[pos.x][pos.y])
		
		# only assigned tokens to the action can be evaluated
		if not copied_token_data:
			continue
		
		combinator.clear_evaluated_combination(cell_index)
		
		var combination : Combination = combinator.search_combinations_for_cell(copied_token_data, cell_index, cell_tokens_ids, true)
		
		if combination.is_valid():
			var current_points:int = 0
			for cell in combination.combinable_cells:
				if __is_cell_empty(cell, cell_tokens_ids):
					continue
				var token_data:TokenData = __token.get_other_token_data_util(cell_tokens_ids[cell.x][cell.y])
				if token_data.reward_type == Constants.RewardType.POINTS:
					current_points += token_data.reward_value
			
			# print("---")
			# print(combination.as_text())
			# print("points: "+ str(current_points))
			
			if current_points > bigger_points:
				bigger_points = current_points
				bigger_combination = combination
				bigger_combination_token_data = copied_token_data
				
	if bigger_combination:
		combinator.replace_combination_at_cell(bigger_combination, cell_index)
		__to_place_token_data = bigger_combination_token_data
		
	combinator.get_combinations_for_cell(cell_index).wildcard_evaluated = true

