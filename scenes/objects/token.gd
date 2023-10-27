extends Node2D

class_name Token

@export var color_highlight_last : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_transparent : Color = Color(1, 1, 1, 0.5)

var floating: bool

var id:String:
	get:
		return data.id

var type:Constants.TokenType:
	get:
		return data.type()	
		
var floor_type:Constants.FloorType:
	get:
		return data.floor_type()		

var behavior: TokenBehavior
var action: TokenAction

var sprite: AnimatedSprite2D
	
var data:TokenData

var created_at:float

func _init():
	created_at = Time.get_unix_time_from_system()
	
func _ready() -> void:
	pass
func _process(delta:float) -> void:
	pass

func set_data(token_data:TokenData) -> void:
	id = token_data.id
	data = token_data
	
	sprite = token_data.sprite_scene.instantiate()
	$SpriteHolder.add_child(sprite)
	$SpriteHolder.position.x = Constants.CELL_SIZE.x / 2
	$SpriteHolder.position.y = Constants.CELL_SIZE.y - Constants.TOKEN_Y_DELTA
	
	for child in sprite.get_children():
		if child is TokenBehavior:
			behavior = child
		if child is TokenAction:
			action = child
	

func unhighlight() -> void:
	highlight(Constants.TokenHighlight.NONE)
	
func highlight(mode:Constants.TokenHighlight) -> void:
	match mode:
		Constants.TokenHighlight.NONE:
			sprite.modulate = Color.WHITE
		Constants.TokenHighlight.INVALID:
			sprite.modulate = color_highlight_invalid
		Constants.TokenHighlight.LAST:
			sprite.modulate = color_highlight_last
		Constants.TokenHighlight.TRANSPARENT:
			sprite.modulate = color_highlight_transparent
		
