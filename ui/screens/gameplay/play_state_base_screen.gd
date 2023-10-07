extends Control

class_name UIPlayStateBaseScreen

var state_id:Constants.UIPlayState:
	get:
		return current_type()

func current_type() -> Constants.UIPlayState:
	return Constants.UIPlayState.NONE

func show_screen() -> void:
	set_process(true)
	show()
	_on_state_enter()

func hide_screen() -> void:
	_on_state_exit()
	set_process(false)

func _on_state_enter() -> void:
	pass
	
func _on_state_exit() -> void:
	pass
