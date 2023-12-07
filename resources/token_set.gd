extends RefCounted

class_name TokenSet

var __common_token_ids: Array[String] = []
var __frequent_token_ids: Array[String] = []
var __rare_token_ids: Array[String] = [] 
var __scarce_token_ids: Array[String] = [] 
var __unique_token_ids: Array[String] = [] 

var __validated : bool

func __validate()  -> void:
	assert(__common_token_ids.size() > 0, "common array should not be empty")
	assert(__frequent_token_ids.size() > 0, "uncommon array should not be empty")
	assert(__rare_token_ids.size() > 0, "rare array should not be empty")
	assert(__scarce_token_ids.size() > 0, "scarce array should not be empty")
	assert(__unique_token_ids.size() > 0, "unique array should not be empty")
	__validated = true

func add_token_id(token_id:String, type:String) -> void:
	match type:
		"0_common":
			__common_token_ids.append(token_id)
		"1_frequent":
			__frequent_token_ids.append(token_id)
		"2_rare":
			__rare_token_ids.append(token_id)
		"3_scarce":
			__scarce_token_ids.append(token_id)
		"4_unique":
			__unique_token_ids.append(token_id)
		"5_never":
			pass
		_:
			assert(false, "type " + type + " is not valid")
	
func get_random_token_data_id() -> String:
	
	var rand_val := randf()
	
	# TODO: validate when the set has no tokens
	
	if rand_val < Constants.TOKEN_PROB_COMMON:
		return __get_random_from_array(__common_token_ids)
	elif rand_val < Constants.TOKEN_PROB_UNCOMMON:
		return __get_random_from_array(__frequent_token_ids)
	elif rand_val < Constants.TOKEN_PROB_RARE:
		return __get_random_from_array(__rare_token_ids)
	elif rand_val < Constants.TOKEN_PROB_SCARCE:
		return __get_random_from_array(__scarce_token_ids)
	else:
		return __get_random_from_array(__unique_token_ids)
		
func __get_random_from_array(arr: Array) -> String:
	return arr[randi() % arr.size()]
