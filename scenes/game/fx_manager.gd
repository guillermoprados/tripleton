extends Node2D

class_name  FxManager

@export var fx_bomb_explosion_scene: PackedScene

func play_bomb_explosion(absolute_position:Vector2) -> void:
	var explosion = fx_bomb_explosion_scene.instantiate()
	var fx_bomb_explosion:AnimatedSprite2D = explosion.get_child(0) as AnimatedSprite2D
	add_child(explosion)
	explosion.position = absolute_position
	fx_bomb_explosion.animation_looped.connect(Callable(__discard_animation).bind(fx_bomb_explosion))
	fx_bomb_explosion.play()
	
func __discard_animation(animation:AnimatedSprite2D) -> void:
	remove_child(animation)
	animation.queue_free()
