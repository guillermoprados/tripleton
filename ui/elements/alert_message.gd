extends Control

class_name TimeoutMessage

@export var message_label:Label
@export var show_timer:Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_timer.timeout.connect(hide_message)
	hide_message()
	
func hide_message() -> void:
	message_label.text = ""
	hide()
	set_process(false)
	
func show_message(message:String, time:float) -> void:
	message_label.text = message
	show_timer.start(time)
	show()
	set_process(true)
