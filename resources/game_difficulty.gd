class_name GameDifficulty extends Resource

@export var maxPoints: int
@export var items: Array[PoolItemResource] = []

func validate_configuration()  -> void:
	assert((maxPoints > 0), "GameDifficulty: maxPoints should be greater than 0.")
	assert((items.size() > 0), "GameDifficulty: Items array should not be empty.")
	for item in items:
		assert((item.token != null), "GameDifficulty: Every PoolItem should have a token assigned.")
		assert((item.number_of_items > 0), "GameDifficulty: Every PoolItem should have a number_of_items greater than 0.")
