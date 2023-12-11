extends Node2D

var gameplay_scene_path:String = "res://scenes/game/gameplay.tscn"

@export var animation_player:AnimationPlayer

func _ready() -> void:
	#animation_player.play("enter_screen")
	pass

func _on_main_menu_new_game_selected() -> void:
	#get_tree().change_scene_to_file(gameplay_scene_path)
	pass
