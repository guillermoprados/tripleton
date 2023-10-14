extends TokenCombinableData

class_name TokenWildcardData

func type() -> Constants.TokenType:
	assert(id == Constants.WILDCARD_ID, "the wildcard id is wrong")
	return Constants.TokenType.WILDCARD
