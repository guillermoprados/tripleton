extends TokenBehavior

class_name ActionMove

enum MOVE_DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func execute_behavior_action(current_cell:Vector2, cell_tokens_ids: Array) -> void:
	print("action!!")
	
