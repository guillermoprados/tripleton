extends Resource

class_name TokensSet

@export var name:String
@export var maxPoints: int
@export var items: Array[PoolItemResource] = []

func validate()  -> void:
	assert(name, "name of set should be set")
	assert((maxPoints > 0), "TokensSet "+name+": maxPoints should be greater than 0.")
	assert((items.size() > 0), "TokensSet "+name+":  Items array should not be empty.")
	for item in items:
		assert((item.item_resource != null), "TokensSet "+name+":  Every PoolItem should have a token assigned.")
		assert((item.amount > 0), "TokensSet "+name+":  Every PoolItem should have a number_of_items greater than 0.")
