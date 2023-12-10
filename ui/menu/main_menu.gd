extends Control

signal new_game_selected()

func _on_but_new_game_pressed() -> void:
	new_game_selected.emit()


func _on_but_collection_pressed() -> void:
	pass # Replace with function body.


func _on_but_option_pressed() -> void:
	pass # Replace with function body.
