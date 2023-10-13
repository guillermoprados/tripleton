extends Resource

class_name TokensSet

@export var maxPoints: int
@export var items: Array[PoolItemResource] = []

func validate_configuration()  -> void:
	assert((maxPoints > 0), "TokensSet: maxPoints should be greater than 0.")
	assert((items.size() > 0), "TokensSet: Items array should not be empty.")
	for item in items:
		assert((item.token != null), "TokensSet: Every PoolItem should have a token assigned.")
		assert((item.number_of_items > 0), "TokensSet: Every PoolItem should have a number_of_items greater than 0.")
