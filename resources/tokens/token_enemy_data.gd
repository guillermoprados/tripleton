extends TokenCombinableData

class_name TokenEnemyData

@export var behavior: PackedScene

func type() -> Constants.TokenType:
	return Constants.TokenType.ENEMY

@export var enemy_type : Constants.EnemyType
