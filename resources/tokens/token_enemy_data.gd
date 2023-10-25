extends TokenCombinableData

class_name TokenEnemyData

func type() -> Constants.TokenType:
	return Constants.TokenType.ENEMY

func floor_type() -> Constants.FloorType:
	return Constants.FloorType.PATH
	
@export var enemy_type : Constants.EnemyType
