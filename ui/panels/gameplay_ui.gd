extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()
	$MessageTimer.timeout.connect(hide_message)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_message():
	$Message.hide()

func _on_gameplay_show_message(message, color_name, time):
	var theme_color = $Message.get_theme().get_color(color_name, "Label")
	if theme_color:  # Check if the color is defined in the theme
		$Message.add_theme_color_override("font_color", theme_color)
	$Message.text = message  # Set the message text
	$Message.show()  # Show the message label
	$MessageTimer.start(time)  # Start the timer
