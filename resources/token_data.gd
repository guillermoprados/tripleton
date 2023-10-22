extends Resource

class_name TokenData

var _name:String

var id:String:
	get:
		if not _name:
			_name = get_name_from_path(get_path())
		return _name

func get_name_from_path(path: String) -> String:
	var filename = path.get_file()
	var name = filename.get_basename()
	return name
	
@export var sprite_scene: PackedScene

func type() -> Constants.TokenType:
	return Constants.TokenType.NORMAL

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
