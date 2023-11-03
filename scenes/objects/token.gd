extends Node2D

class_name Token

@export var color_highlight_last : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var color_highlight_transparent : Color = Color(1, 1, 1, 0.5)

@export var floating_shader:ShaderMaterial
@export var outline_shader:ShaderMaterial

@export var sprite_holder:Node2D
@export var shadow:Node2D
@export var in_range_tweener:InRangeTweener

var _floating: bool

var floating: bool:
	get:
		return _floating
	set (value):
		_floating = value
		if _floating:
			sprite_holder.position.y = Constants.TOKEN_FLOATING_Y_POS
			shadow.scale = Vector2(Constants.TOKEN_SHADOW_FLOATING_MULTIPLIER, Constants.TOKEN_SHADOW_FLOATING_MULTIPLIER)
			sprite.material = floating_shader
			# sprite.get_material().set_shader_parameter("line_color", Color(1.0, 1.0, 1.0))
			# sprite.get_material().set_shader_parameter("line_thickness", 4.0)  # Adjust the size as needed
		else:
			sprite_holder.position.y = Constants.TOKEN_PLACED_Y_POS
			shadow.scale = Vector2(1, 1)
			sprite.material = outline_shader
			
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
	
func _process(delta:float) -> void:
	pass

func set_data(token_data:TokenData) -> void:
	id = token_data.id
	data = token_data
	
	sprite = token_data.sprite_scene.instantiate()
	sprite.material = outline_shader
	sprite_holder.add_child(sprite)
	sprite_holder.position.x = Constants.CELL_SIZE.x / 2
	sprite_holder.position.y = Constants.TOKEN_PLACED_Y_POS
	shadow.position.x = Constants.CELL_SIZE.x / 2
	shadow.position.y = Constants.TOKEN_SHADOW_Y_POS
	
	
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

func set_in_range(difference_pos:Vector2) -> void:
	in_range_tweener.set_in_range_tweener(difference_pos)
	
func clear_in_range() -> void:
	in_range_tweener.clear_in_range()
