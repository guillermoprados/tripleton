extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path := resource.get_path()
	var filename := path.get_file()
	var name := filename.get_basename()
	return name

static func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()


# Static method to copy the cell_tokens_ids
static func copy_array_matrix(original: Array) -> Array:
	var copy: Array = []
	for row in original:
		var row_copy: Array = row.duplicate()
		copy.append(row_copy)
	return copy

static func token_type_as_string(type:Constants.TokenType) -> String:
	
	match type:
		Constants.TokenType.NORMAL:
			return "normal"
		Constants.TokenType.ACTION:
			return "action"
		Constants.TokenType.ENEMY:
			return "enemy"
		Constants.TokenType.CHEST:
			return "chest"
		Constants.TokenType.PRIZE:
			return "prize"
			
	return "Unknown"

static func token_action_type_as_string(type:Constants.ActionType) -> String:
	
	match type:
		Constants.ActionType.BOMB:
			return "bomb"
		Constants.ActionType.LEVEL_UP:
			return "level_up"
		Constants.ActionType.WILDCARD:
			return "wildcard"
		Constants.ActionType.REMOVE_ALL:
			return "remove_all"
		Constants.ActionType.MOVE:
			return "move"
			
	return "Unknown"

static func reward_type_as_string(type:Constants.RewardType) -> String:
	match type:
		Constants.RewardType.GOLD:
			return "gold"
		Constants.RewardType.POINTS:
			return "points"
		Constants.RewardType.NONE:
			return "none"
	return "unknown"
