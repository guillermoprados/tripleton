extends CanvasLayer

class_name GameplayUI

var available_uis: Dictionary = {}
var active_ui: UIPlayScreenIdBaseScreen

@export var console_log : bool
@export var screen_fader: ScreenFader

signal play_again()

func _ready() -> void:
	for node in get_children():
		if node is UIPlayScreenIdBaseScreen:
			available_uis[node.id] = node
			node.hide()
	# fade_to_transparent()

func fade_to_black() -> void:
	screen_fader.fade_in(1)

func fade_to_transparent() -> void:
	screen_fader.fade_out(1)

func switch_ui(show_ui:Constants.UIPlayScreenId)-> void:
	
	if active_ui and show_ui == active_ui.id:
		return
	
	if active_ui:
		if console_log:
			print(" x close ui: "+ __state_name(active_ui.id))
		active_ui.hide_screen()
		active_ui = null
	
	if available_uis.has(show_ui):
		active_ui = available_uis[show_ui]
	else:
		assert(false, " x cannot find "+__state_name(show_ui))
		
	if active_ui:
		if console_log:
			print(" > show ui: "+ __state_name(active_ui.id))
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

func _on_game_manager_dinasty_changed(name, max_points, overflow):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.set_dinasty(name, max_points, overflow)

func _on_game_manager_gold_updated(value):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_gold_update(value)

func _on_game_manager_points_updated(updated_points:int, dinasty_points: int, total_points:int):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_points_update(total_points)
		playing_ui.set_dinasty_progress(dinasty_points)
		
func _on_game_manager_show_floating_reward(type, value, position):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_floating_reward(type, value, position)


func _on_game_manager_show_message(message, type, time):
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_message(message, type, time)


func _on_game_over_screen_play_again():
	play_again.emit()


