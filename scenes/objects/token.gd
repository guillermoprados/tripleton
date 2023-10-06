extends Node2D

class_name Token

@export var token_predefined_size: Vector2 = Vector2(128, 128)  # default size, you can adjust it in the editor

var floating: bool
var token_size: Vector2 = token_predefined_size
 
var id:String = Constants.INVALID_TOKEN_ID
var data:TokenData

func _ready() -> void:
	pass  # Replace with function body.

func _process(delta:float) -> void:
	pass

# Method to set the size of the AnimatedSprite
func set_size(new_size: Vector2) -> void:
	token_size = new_size
	self.scale = new_size / token_predefined_size

# Overriding the _draw() method to draw our debug rectangle
func _draw() -> void:
	# Drawing a rectangle at the token's position with the token's size
	# The color is set to red for visibility, but you can change it as per your preference
	draw_rect(Rect2(Vector2.ZERO, token_predefined_size), Color(1, 0, 0, 0.5), false)

func set_data(token_data:TokenData) -> void:
	id = token_data.id
	data = token_data
	var sprite_instance:AnimatedSprite2D = token_data.sprite_scene.instantiate()
	add_child(sprite_instance)
