extends TokenCombinableData

class_name TokenChestData

func type() -> Constants.TokenType:
	return Constants.TokenType.CHEST

var __prizes: TokenSet

var __current_prize_id:String

func add_prizes(prizes:TokenSet) -> void:
	__prizes = prizes

# we only calculate the prize once (which makes testing easier)
func get_random_prize_id() -> String:
	if __current_prize_id == '':
		__current_prize_id = __prizes.get_random_token_data_id()
	return __current_prize_id

func _to_string() -> String:
	var info := super._to_string()
	info +="\n [ TODO: print chest prizes"
	#for prize:String in prizes.keys():
	#	info += prize+" "
	info +="]"
	
	return info 
	
