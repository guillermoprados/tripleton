extends CanvasLayer

class_name GameplayUI

var current_state: Constants.UIPlayState = Constants.UIPlayState.NONE
var state_uis: Dictionary = {}
var active_ui: UIPlayStateBaseScreen

func _ready() -> void:
	for node in get_children():
		if node is UIPlayStateBaseScreen:
			state_uis[node.state_id] = node
			node.hide()

func switch_state(new_state:Constants.UIPlayState)-> void:
	if active_ui:
		print(" xx state: "+ __state_name(active_ui.state_id))
		active_ui.show_screen()
	
	active_ui = state_uis[new_state]
	
	if active_ui:
		print(" >> state: "+ __state_name(active_ui.state_id))
		active_ui.hide_screen()

func __state_name(state:Constants.UIPlayState) -> String:
	match state:
		Constants.UIPlayState.NONE:
			return "None"
		Constants.UIPlayState.INTRO:
			return "Intro UI"
		Constants.UIPlayState.PLAYING:
			return "Playing UI"
		Constants.UIPlayState.GAME_OVER:
			return "Game Over UI"
		Constants.UIPlayState.PAUSE:
			return "Paused UI"
		_:
			return "I DONT KNOW"
