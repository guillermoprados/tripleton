extends TokenData

class_name TokenActionData

@export var action: PackedScene

func type() -> Constants.TokenType:
	return Constants.TokenType.ACTION
	
@export var action_type : Constants.ActionType

