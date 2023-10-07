extends Control

class_name UIPlayStateBaseScreen

func state_id() -> Constants.UIPlayState:
	return Constants.UIPlayState.NONE

func show_screen() -> void:
	show()
	_on_state_enter()

func hide_screen() -> void:
	_on_state_exit()

func _on_state_enter() -> void:
	pass
	
func _on_state_exit() -> void:
	pass
