extends TokenPrizeData

class_name TokenCombinableData

@export var next_token: TokenData

func type() -> Constants.TokenType:
	return Constants.TokenType.NORMAL

func has_next_token() -> bool:
	return next_token != null
