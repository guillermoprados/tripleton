extends RefCounted

class_name Utils

static func get_name_from_resource(resource: Resource) -> String:
	var path := resource.get_path()
	var filename := path.get_file()
	var name := filename.get_basename()
	return name

static func is_valid_cell(cell: Vector2, matrix: Array) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < matrix.size() and cell.y < matrix[0].size()

static func indexToVector2(index: int, rows: int, columns: int) -> Vector2:
	var row := int(index % columns)
	var col := int(index / columns)
	return Vector2(col, row)

# Static method to copy the cell_tokens_ids
static func copy_array_matrix(original: Array) -> Array:
	var copy: Array = []
	for row:Array in original:
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

static func reward_type_from_string(type:String) -> Constants.RewardType:
	match type:
		"gold":
			return Constants.RewardType.GOLD
		"points":
			return Constants.RewardType.POINTS
		"none":
			return Constants.RewardType.NONE
	assert(false, "type "+type+" not found")
	return Constants.RewardType.NONE

static func set_frecuency_to_string(frecuency:Constants.SetFrecuency) -> String:
	match frecuency:
		Constants.SetFrecuency.COMMON:
			return "0_common"
		Constants.SetFrecuency.FREQUENT:
			return "1_frequent"
		Constants.SetFrecuency.RARE:
			return "2_rare"
		Constants.SetFrecuency.SCARCE:
			return "3_scarce"
		Constants.SetFrecuency.UNIQUE:
			return "4_unique"
		Constants.SetFrecuency.NEVER:
			return "5_never"
		_:
			assert(false, "Invalid Frecuency:"+str(frecuency))
			return "wtf"
			
static func set_frecuency_from_string(frecuency:String) -> Constants.SetFrecuency:
	match frecuency:
		"0_common":
			return Constants.SetFrecuency.COMMON
		"1_frequent":
			return Constants.SetFrecuency.FREQUENT
		"2_rare":
			return Constants.SetFrecuency.RARE
		"3_scarce":
			return Constants.SetFrecuency.SCARCE
		"4_unique":
			return Constants.SetFrecuency.UNIQUE
		"5_never":
			return Constants.SetFrecuency.NEVER
		_:
			assert(false, "Invalid Frecuency:"+str(frecuency))
			return Constants.SetFrecuency.COMMON


