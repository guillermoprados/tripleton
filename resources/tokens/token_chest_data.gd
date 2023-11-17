extends TokenCombinableData

class_name TokenChestData

func type() -> Constants.TokenType:
	return Constants.TokenType.CHEST

@export var prizes: Array[TokenData]

# we only calculate the value of the prize once, 
# so we can compare it on tests when we call it again
var __prize_index:int

func get_random_prize() -> TokenData:
	assert(prizes.size() > 0, "This chest is empty")
	if not __prize_index:
		randomize()
		var random_index:int = randi() % prizes.size()
		__prize_index = random_index
	return prizes[__prize_index]
