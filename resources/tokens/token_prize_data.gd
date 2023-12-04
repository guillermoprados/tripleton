extends TokenData

class_name TokenPrizeData

var __reward_type:Constants.RewardType
var reward_type: Constants.RewardType:
	get:
		return __reward_type
		
var __reward_value:int
var reward_value: int:
	get:
		return __reward_value
		
var __collectable:bool
var is_collectable: bool:
	get:
		return __collectable
	
func type() -> Constants.TokenType:
	return Constants.TokenType.PRIZE

func _to_string() -> String:
	var info = super._to_string()
	info +="\n"
	info += "reward_type: " + Utils.reward_type_as_string(reward_type) + "\n"
	info += "reward_value: " + str(reward_value) + "\n"
	info += "collectable: " + str(is_collectable)
	return info 

