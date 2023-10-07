extends Node2D

class_name Token

@export var token_predefined_size: Vector2 = Vector2(128, 128)  # default size, you can adjust it in the editor

var floating: bool
var token_size: Vector2 = token_predefined_size

var id:String:
	get:
		return data.id

var type:Constants.TokenType:
	get:
		return data.type		

var _behavior: TokenBehavior

var behavior: TokenBehavior:
	get: 
		return _behavior
	set(value):
		_behavior = value
	
var data:TokenData

func _ready() -> void:
	pass  # Replace with function body.

func _process(delta:float) -> void:
	pass

# Method to set the size of the AnimatedSprite
func set_size(new_size: Vector2) -> void:
	token_size = new_size
	self.scale = new_size / token_predefined_size

func set_data(token_data:TokenData) -> void:
	id = token_data.id
	data = token_data
	var sprite_instance:AnimatedSprite2D = token_data.sprite_scene.instantiate()
	add_child(sprite_instance)
	
	if data.behavior:
		behavior = token_data.behavior.instantiate()
		add_child(behavior)
