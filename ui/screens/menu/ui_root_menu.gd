extends CanvasLayer

@export var mm_background:MainMenuBackground
@export var screen_fader:ScreenFader

var gameplay_scene_path:String = "res://scenes/game/gameplay.tscn"

func _ready() -> void:
	if mm_background:
		mm_background.animate_from_sky()
	screen_fader.fade_to_transparent(1)

func _on_main_menu_new_game_selected() -> void:
	if mm_background:
		mm_background.animate_to_city()
	screen_fader.fade_to_black(Constants.TO_CITY_ANIM_TIME)
	await get_tree().create_timer(randf_range(0,2)).timeout
	get_tree().change_scene_to_file(gameplay_scene_path)
