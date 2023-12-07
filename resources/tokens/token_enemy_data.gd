extends TokenCombinableData

class_name TokenEnemyData

func type() -> Constants.TokenType:
	return Constants.TokenType.ENEMY

func floor_type() -> Constants.FloorType:
	return Constants.FloorType.PATH
	
@export var enemy_type : Constants.EnemyType

func _to_string() -> String:
	var info := super._to_string()
	info +="\n"
	info += "enemy_type:" + "TODO"
	return info 
