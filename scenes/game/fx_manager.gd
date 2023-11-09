extends Node2D

class_name  FxManager

@export var board:Board
@export var fx_bomb_explosion_scene: PackedScene
@export var fx_select_cell_scene: PackedScene

func _ready() -> void:
	z_index = Constants.FX_Z_INDEX
	
func play_bomb_explosion(in_board_pos:Vector2) -> void:
	var explosion = fx_bomb_explosion_scene.instantiate()
	var fx_bomb_explosion:AnimatedSprite2D = explosion.get_child(0) as AnimatedSprite2D
	add_child(explosion)
	explosion.position = board.position + in_board_pos
	fx_bomb_explosion.animation_looped.connect(Callable(__discard_animation).bind(fx_bomb_explosion))
	fx_bomb_explosion.play()

func play_select_cell_animation(in_board_pos:Vector2) -> void:
	var select_cell = fx_select_cell_scene.instantiate()
	var fx_select_cell:AnimatedSprite2D = select_cell.get_child(0) as AnimatedSprite2D
	$SelectCellAnims.add_child(select_cell)
	select_cell.position = board.position + in_board_pos
	fx_select_cell.play()

func stop_select_cell_anims() -> void:
	for child in $SelectCellAnims.get_children(false):
		child.queue_free()

func __discard_animation(animation:AnimatedSprite2D) -> void:
	remove_child(animation)
	animation.queue_free()
