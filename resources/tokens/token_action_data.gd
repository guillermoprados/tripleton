extends TokenData

class_name TokenActionData

func type() -> Constants.TokenType:
	return Constants.TokenType.ACTION
	
@export var action_type : Constants.ActionType

func _to_string() -> String:
	var info = super._to_string()
	info +="\n"
	info += "action_type: " + Utils.token_action_type_as_string(action_type)
	return info 
