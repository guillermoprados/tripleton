extends Control

signal new_game_selected()

var gameplay_scene_path:String = "res://scenes/game/gameplay.tscn"

@export var screen_fader:ScreenFader

func _on_but_new_game_pressed() -> void:
	new_game_selected.emit()
	#get_tree().change_scene_to_file(gameplay_scene_path)

func _on_but_collection_pressed() -> void:
	pass # Replace with function body.


func _on_but_option_pressed() -> void:
	pass # Replace with function body.
