extends TokenAction

class_name ActionBomb

@export var explosion_scene: PackedScene

func __surrounding_cells(current_cell:Vector2) -> Array[Vector2]:
	var surrounding_cells : Array[Vector2] = []
#   disabling for now surrounding cells
#	surrounding_cells.append(current_cell + Vector2(0, - 1))
#	surrounding_cells.append(current_cell + Vector2(1, - 1))
#	surrounding_cells.append(current_cell + Vector2(1, 0))
#	surrounding_cells.append(current_cell + Vector2(1, 1))
#	surrounding_cells.append(current_cell + Vector2(0, 1))
#	surrounding_cells.append(current_cell + Vector2(- 1, - 1))
#	surrounding_cells.append(current_cell + Vector2(- 1, 0))
#   surrounding_cells.append(current_cell + Vector2(- 1, 1))
	return surrounding_cells
	
func affected_cells(current_cell:Vector2, cell_tokens_ids: Array) -> Array[Vector2]:
	var cells : Array[Vector2] = []
	
	for surrounding_cell in __surrounding_cells(current_cell):
		if is_valid_cell(surrounding_cell, cell_tokens_ids):
			cells.append(surrounding_cell)
	
	cells.append(current_cell)
	
	return cells
	
func is_valid_action(action_cell:Vector2, cell_tokens_ids: Array) -> bool:
	return true

func execute_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	var cells_to_destroy:Array[Vector2] = affected_cells(current_cell, cell_tokens_ids)
	for cell in cells_to_destroy:
		destroy_token_at_cell.emit(cell)
	
	var bomb_sprite:AnimatedSprite2D = get_parent() as AnimatedSprite2D
	bomb_sprite.hide()
	
	disable_interactions.emit()
	
	var explosion:AnimatedSprite2D = explosion_scene.instantiate() as AnimatedSprite2D
	bomb_sprite.get_parent().add_child(explosion)
	explosion.animation_looped.connect(animation_finished)
	explosion.play()

func animation_finished() -> void:
	action_finished.emit()
	
