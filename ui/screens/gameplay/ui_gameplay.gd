extends CanvasLayer

class_name GameplayUI

var available_uis: Dictionary = {}
var active_ui: UIPlayScreenIdBaseScreen

func _ready() -> void:
	for node in get_children():
		if node is UIPlayScreenIdBaseScreen:
			available_uis[node.id] = node
			node.hide()

func switch_ui(show_ui:Constants.UIPlayScreenId)-> void:
	print(" >> show ui: "+ __state_name(show_ui))
	
	if active_ui and show_ui == active_ui.id:
		return
	
	if active_ui:
		print(" close ui: "+ __state_name(active_ui.id))
		active_ui.hide_screen()
		active_ui = null
	
	if available_uis.has(show_ui):
		active_ui = available_uis[show_ui]
	
	if active_ui:
		print(" show ui: "+ __state_name(active_ui.id))
		active_ui.show_screen()

func __state_name(id:Constants.UIPlayScreenId) -> String:
	match id:
		Constants.UIPlayScreenId.NONE:
			return "None"
		Constants.UIPlayScreenId.INTRO:
			return "Intro UI"
		Constants.UIPlayScreenId.PLAYING:
			return "Playing UI"
		Constants.UIPlayScreenId.GAME_OVER:
			return "Game Over UI"
		Constants.UIPlayScreenId.PAUSE:
			return "Paused UI"
		_:
			return "I DONT KNOW"


func _on_game_manager_gold_updated(value):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_gold_update(value)

func _on_game_manager_points_updated(value):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_points_update(value)


func _on_player_turn_state_show_floating_reward(type, value, position):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_floating_reward(type, value, position)


func _on_player_turn_state_show_message(message, type, time):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_message(message, type, time)
