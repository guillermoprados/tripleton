class_name GameDifficulty extends Resource

@export var name: String
@export var maxPoints: int
@export var items: Array[DifficultyItem] = []

func validate_configuration():
	assert((name != null && name != ""), "GameDifficulty: Name should not be empty.")
	assert((maxPoints > 0), "GameDifficulty: maxPoints should be greater than 0.")
	assert((items.size() > 0), "GameDifficulty: Items array should not be empty.")
	for item in items:
		assert((item.token != null), "GameDifficulty: Every DifficultyItem should have a token assigned.")
		assert((item.number_of_items > 0), "GameDifficulty: Every DifficultyItem should have a number_of_items greater than 0.")
