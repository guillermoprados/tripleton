extends UIPlayScreenIdBaseScreen

class_name GameOverStateUI 

signal play_again()

func screen_id() -> Constants.UIPlayScreenId:
	return Constants.UIPlayScreenId.GAME_OVER

func _on_screen_enter() -> void:
	pass
	
func _on_screen_exit() -> void:
	pass


func _on_play_again_pressed() -> void:
	play_again.emit()
