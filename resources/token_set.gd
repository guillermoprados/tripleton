extends RefCounted

class_name TokenSet

var tokens_id_by_frequency:Dictionary = {
	Constants.SetFrecuency.COMMON:[],
	Constants.SetFrecuency.FREQUENT:[],
	Constants.SetFrecuency.RARE:[],
	Constants.SetFrecuency.SCARCE:[],
	Constants.SetFrecuency.UNIQUE:[],
	Constants.SetFrecuency.NEVER:[],
}

func add_token_id(token_id:String, frecuency_id:String) -> void:
	var set_frecuency:= Utils.set_frecuency_from_string(frecuency_id)
	tokens_id_by_frequency[set_frecuency].append(token_id)
	
func get_random_token_data_id() -> String:
	var rand_val := randf()
	
	var frecuency_to_use : Constants.SetFrecuency 
	# TODO: validate when the set has no tokens
	
	if rand_val < Constants.TOKEN_PROB_COMMON:
		frecuency_to_use = Constants.SetFrecuency.COMMON
	elif rand_val < Constants.TOKEN_PROB_FREQUENT:
		frecuency_to_use = Constants.SetFrecuency.FREQUENT
	elif rand_val < Constants.TOKEN_PROB_RARE:
		frecuency_to_use = Constants.SetFrecuency.RARE
	elif rand_val < Constants.TOKEN_PROB_SCARCE:
		frecuency_to_use = Constants.SetFrecuency.SCARCE
	else:
		frecuency_to_use = Constants.SetFrecuency.UNIQUE
	
	var token_id:String = ''
	while token_id == '':
		if tokens_id_by_frequency[frecuency_to_use].size() > 0:
			token_id = __get_random_from_array(tokens_id_by_frequency[frecuency_to_use])
		else:
			frecuency_to_use -= 1
			if frecuency_to_use == -1:
				assert("there are no tokens available for this set")
	return token_id
	
func __get_random_from_array(arr: Array) -> String:
	return arr[randi() % arr.size()]
