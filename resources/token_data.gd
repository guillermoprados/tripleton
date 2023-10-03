extends Resource

class_name TokenData

@export var id: String
@export var sprite_scene: PackedScene
@export var points: int = 0
@export var gold: int = 0
@export var is_chest: bool
@export var is_prize: bool

func clone() -> TokenData:
	var new_token_data = TokenData.new()
	
	# Copy properties
	new_token_data.id = id
	new_token_data.sprite_scene = sprite_scene  # Shared reference is okay
	new_token_data.points = points
	new_token_data.gold = gold
	new_token_data.is_chest = is_chest
	new_token_data.is_prize = is_prize
	
	return new_token_data
