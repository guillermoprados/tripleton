extends Node2D

var gameplay_scene_path:String = "res://scenes/game/gameplay.tscn"

@export var background:MainMenuBackground

func _ready() -> void:
	background.animate_from_sky()

func _on_main_menu_new_game_selected() -> void:
	#get_tree().change_scene_to_file(gameplay_scene_path)
	pass
