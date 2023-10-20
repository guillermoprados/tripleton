extends TokenData

class_name TokenPrizeData

@export var reward_type: Constants.RewardType
@export var reward_value: int = 0
@export var collectable: bool = false

func type() -> Constants.TokenType:
	return Constants.TokenType.PRIZE
