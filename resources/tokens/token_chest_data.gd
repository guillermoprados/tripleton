extends TokenCombinableData

class_name TokenChestData

func type() -> Constants.TokenType:
	return Constants.TokenType.CHEST

var __prizes: Dictionary
var prizes: Dictionary:
	get: 
		return __prizes

var __current_prize_id:String

# we only calculate the prize once (which makes testing easier)
func get_random_prize_id() -> String:
	assert(prizes.keys().size() > 0, "This chest is empty")
	var random_prize_id := ''
	if __current_prize_id == '':
		randomize()
		var total_probability := 0
		# Calculate the total probability
		for probability:int in prizes.values():
			total_probability += probability

		# Generate a random value within the total probability range
		var random_value := randi() % int(total_probability)

		# Iterate through the objects and find the selected one
		var current_probability := 0
		for prize_id:String in prizes.keys():
			current_probability += prizes[prize_id]
			if random_value < current_probability:
				random_prize_id = prize_id
				break
		__current_prize_id = random_prize_id

	assert(__current_prize_id != '', "you should not be here")
	return __current_prize_id

func _to_string() -> String:
	var info := super._to_string()
	info +="\n [ "
	for prize:String in prizes.keys():
		info += prize+" "
	info +="]"
	
	return info 
	
