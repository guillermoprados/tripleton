extends TokenCombinableData

class_name TokenChestData

func type() -> Constants.TokenType:
	return Constants.TokenType.CHEST

@export var prizes: Array[TokenData]

# we only calculate the value of the prize once, 
# so we can compare it on tests when we call it again
var __current_prize_data:TokenData

func get_random_prize() -> TokenData:
	assert(prizes.size() > 0, "This chest is empty")
	if not __current_prize_data:
		randomize()
		var random_index:int = randi() % prizes.size()
		__current_prize_data = prizes[random_index]
	return __current_prize_data

func _to_string() -> String:
	var info = super._to_string()
	info +="\n [ "
	for prize in prizes:
		info += prize.id+" "
	info +="]"
	
	return info 
