extends CanvasLayer

@export var mm_background:MainMenuBackground
@export var screen_fader:ScreenFader

func _ready() -> void:
	if mm_background:
		mm_background.animate_from_sky()
	screen_fader.fade_to_transparent(1)

func _on_main_menu_new_game_selected() -> void:
	if mm_background:
		mm_background.animate_to_city()
	screen_fader.fade_to_black(0.5)
