extends Control

class_name UIPlayScreenIdBaseScreen

var id:Constants.UIPlayScreenId:
	get:
		return current_type()

func current_type() -> Constants.UIPlayScreenId:
	return Constants.UIPlayScreenId.NONE

func show_screen() -> void:
	set_process(true)
	show()
	_on_screen_enter()

func hide_screen() -> void:
	_on_screen_exit()
	set_process(false)

func _on_screen_enter() -> void:
	pass
	
func _on_screen_exit() -> void:
	pass
