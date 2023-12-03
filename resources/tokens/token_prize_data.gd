extends TokenData

class_name TokenPrizeData

@export var reward_type: Constants.RewardType
@export var reward_value: int = 0
@export var collectable: bool = false

func type() -> Constants.TokenType:
	return Constants.TokenType.PRIZE

func _to_string() -> String:
	var info = super._to_string()
	info +="\n"
	info += "reward_type: " + Utils.reward_type_as_string(reward_type) + "\n"
	info += "reward_value: " + str(reward_value) + "\n"
	info += "collectable: " + str(collectable)
	return info 

