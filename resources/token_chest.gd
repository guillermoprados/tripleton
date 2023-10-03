extends Resource

class_name TokenChest

@export var chest:TokenData
@export var prizes: Array[TokenData]

func get_random_prize() -> TokenData:
	assert(prizes.size() > 0, "This chest is empty")
	randomize()
	var random_index = randi() % prizes.size()
	return prizes[random_index]
