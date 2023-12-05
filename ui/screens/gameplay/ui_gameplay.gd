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

func _on_game_manager_gold_added(added_gold:int, game_gold:int) -> void:
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_gold_update(game_gold)

func _on_game_manager_points_added(added_points:int, difficulty_points: int, game_points:int) -> void:
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.accumulated_points_update(game_points)
		playing_ui.set_dinasty_progress(difficulty_points)
		
func _on_game_manager_show_floating_reward(type:Constants.RewardType, value:int, position:Vector2) -> void:
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_floating_reward(type, value, position)


func _on_game_manager_show_message(message:String, type:Constants.MessageType, time:float) -> void:
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.show_message(message, type, time)

func _on_game_over_screen_play_again() -> void:
	play_again.emit()

func _on_game_manager_difficulty_changed(name:String, total_points:int) -> void:
	if active_ui.id == Constants.UIPlayScreenId.PLAYING:
		var playing_ui:PlayingStateUI = active_ui as PlayingStateUI
		playing_ui.set_dinasty(name, total_points)
