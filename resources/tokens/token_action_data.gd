extends TokenData

class_name TokenActionData

func type() -> Constants.TokenType:
	return Constants.TokenType.ACTION
	
@export var action_type : Constants.ActionType

