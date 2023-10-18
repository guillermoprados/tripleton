extends Resource

class_name TokenData

@export var id:String

@export var sprite_scene: PackedScene

@export var reward_type: Constants.RewardType
@export var reward_value: int = 0

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
