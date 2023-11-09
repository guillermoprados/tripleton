extends Node2D

class_name TokenSpriteHolder

var sprite : AnimatedSprite2D 
var shadow : Sprite2D

var sprite_original_position : Vector2 
var shadow_original_scale : Vector2

var floating_shader : ShaderMaterial
var outline_shader : ShaderMaterial
var outline_last_shader : ShaderMaterial

func set_boxed() -> void:
	sprite.show()
	sprite.position.y = sprite_original_position.y - Constants.TOKEN_BOXED_Y_POS
	sprite.material = outline_shader
	shadow.hide()
	
func set_floating() -> void:
	sprite.show()
	sprite.position.y = sprite_original_position.y - Constants.TOKEN_FLOATING_Y_POS
	sprite.material = floating_shader
	shadow.show()
	shadow.scale = shadow_original_scale * Constants.TOKEN_SHADOW_FLOATING_MULTIPLIER
			
func set_placed() -> void:
	sprite.show()
	sprite.position.y = sprite_original_position.y
	sprite.material = outline_shader
	shadow.show()
	shadow.scale = shadow_original_scale

func set_in_range() -> void:
	sprite.show()
	sprite.position.y = sprite_original_position.y - Constants.TOKEN_IN_RANGE_Y_POS
	sprite.material = outline_shader
	shadow.show()
	shadow.scale = shadow_original_scale * Constants.TOKEN_SHADOW_IN_RANGE_MULTIPLIER

func set_invisible() -> void:
	shadow.hide()
	sprite.hide()
	
func paint_last() -> void:
	sprite.material = outline_last_shader
	
func paint_normal() -> void:
	sprite.material = outline_shader
	
func paint_floating(border_color:Color, overlay_color:Color) -> void:
	sprite.material = floating_shader
	sprite.get_material().set_shader_parameter("overlay_color", overlay_color)
	sprite.get_material().set_shader_parameter("line_color", border_color)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	floating_shader = load("res://materials/floating_material.tres")
	outline_shader = load("res://materials/outline_material.tres")
	outline_last_shader = load("res://materials/last_placed_material.tres")
	
	sprite = $Sprite
	shadow = $Shadow
	
	assert(sprite, "please asign sprite to the token")
	assert(shadow, "please asign shadow to the token")
	assert(floating_shader, "cannot load floating shader")
	assert(outline_shader, "cannot load outline shader")
	
	position = Vector2(0, (Constants.CELL_SIZE.y / 2) - Constants.TOKEN_SPRITE_HOLDER_Y)
	sprite_original_position = sprite.position
	shadow.position = Vector2(0, Constants.TOKEN_SHADOW_Y_POS + 2 ) # +2 because of the border
	shadow_original_scale = shadow.scale
	sprite.material = outline_shader
	
