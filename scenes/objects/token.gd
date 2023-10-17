extends Node2D

class_name Token

var floating: bool

var id:String:
	get:
		return data.id

var type:Constants.TokenType:
	get:
		return data.type()		

var _behavior: TokenBehavior

var behavior: TokenBehavior:
	get: 
		return _behavior
	set(value):
		_behavior = value
	
var data:TokenData

var created_at:float

func _init():
	created_at = Time.get_unix_time_from_system()
	
func _ready() -> void:
	adjust_size(Constants.CELL_SIZE)

func _process(delta:float) -> void:
	pass

# Method to set the size of the AnimatedSprite
func adjust_size(new_size: Vector2) -> void:
	self.scale = new_size / Constants.TOKEN_SPRITE_SIZE

func set_data(token_data:TokenData) -> void:
	id = token_data.id
	data = token_data
	var sprite_instance:AnimatedSprite2D = token_data.sprite_scene.instantiate()
	add_child(sprite_instance)
	
	if data.type() == Constants.TokenType.ENEMY:
		behavior = token_data.behavior.instantiate()
		add_child(behavior)
