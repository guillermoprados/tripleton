extends TokenPrizeData

class_name TokenCombinableData

var next_token_id: String

func type() -> Constants.TokenType:
	return Constants.TokenType.NORMAL

func has_next_token() -> bool:
	return next_token_id != ''

#TODO: check: do I need this level variable? :thinking:
var level: int:
	get:
		assert(__starts_with_number(id), "this token needs to be set with a n_id name type")
		var id_str := str(id)
		var first_char := id_str.substr(0, 1).to_int()
		return first_char
	
func __starts_with_number(s: String) -> bool:
	# Regular expression to match a string that starts with a number
	var regex := RegEx.new()
	regex.compile("^[0-9]")
	# Test if the string matches the pattern
	return regex.search(s) != null

func _to_string() -> String:
	var info = super._to_string()
	info +="\n"
	info += "next_token: " +next_token_id
	return info 
