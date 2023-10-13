extends Resource

class_name  LevelConfig

@export var name: String
@export var tokens_sets: Array[TokensSet] = []

func validate() -> void :
	for set in tokens_sets:
		assert(name, "Plase assign a name")
		assert(set, "There are empty sets assigned to this config:"+name)
		set.validate()
