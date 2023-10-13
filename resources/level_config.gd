extends Resource

class_name  LevelConfig

@export var tokens_sets: Array[TokensSet] = []

func validate() -> void :
	for set in tokens_sets:
		set.validate()
