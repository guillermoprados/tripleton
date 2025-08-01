extends Resource

class_name TokenData

var _name:String

var id:String:
	get:
		if not _name:
			_name = Utils.get_name_from_resource(self)
		return _name

@export var sprite_scene: PackedScene

func type() -> Constants.TokenType:
	return Constants.TokenType.NORMAL

func floor_type() -> Constants.FloorType:
	return Constants.FloorType.GRASS

func validate() -> void:
	# Check ID
	assert(id != null, "ID cannot be null.")
	assert(id != "", "ID cannot be empty.")
	assert(id.find(" ") == -1, "ID should be a single word.")
	assert(id.is_valid_identifier(), "ID should only have valid characters.")
	
	# Check sprite_scene
	assert(sprite_scene != null, "sprite_scene cannot be null.")

	# Check behavior
	# assert(behavior != null, "sprite_scene cannot be null.")

func _to_string() -> String:
	var info := "id: " +id +" \n"
	info += "type: " +Utils.token_type_as_string(type())
	return info 
