extends Control

class_name ScreenFader

signal faded_in()
signal faded_out()

@export var screen_rect: ColorRect

func _ready():
	self.visible = true
	
func fade_in(time: float) -> void:
	var tween = create_tween()
	tween.loop_finished.connect(self._on_fade_in_completed)
	tween.tween_property(screen_rect, "color", Color(0, 0, 0, 1), time)

func fade_out(time: float) -> void:
	var tween = create_tween()
	tween.loop_finished.connect(self._on_fade_out_completed)
	tween.tween_property(screen_rect, "color", Color(0, 0, 0, 0), time)

func _on_fade_in_completed() -> void:
	emit_signal("faded_in")

func _on_fade_out_completed() -> void:
	emit_signal("faded_out")
