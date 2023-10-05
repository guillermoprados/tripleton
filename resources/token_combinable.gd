extends TokenData

class_name TokenCombinable

@export var next_token: TokenData

func has_next_token() -> bool:
	return next_token != null
