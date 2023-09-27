extends CanvasLayer

var total_points:int = 0

var points_label:Label
var message_label:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	points_label = $Points
	message_label = $Message
	reset()

func reset():
	total_points = 0 
	points_label.text = str(total_points)
	message_label.hide()
	$MessageTimer.timeout.connect(hide_message)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	points_label.text = str(total_points)

func hide_message():
	message_label.hide()

func _on_gameplay_show_message(message, color_name, time):
	var theme_color = message_label.get_theme().get_color(color_name, "Label")
	if theme_color:  # Check if the color is defined in the theme
		message_label.add_theme_color_override("font_color", theme_color)
	message_label.text = message  # Set the message text
	message_label.show()  # Show the message label
	$MessageTimer.start(time)  # Start the timer


func _on_gameplay_points_received(points, position):
	pass # Replace with function body.


func _on_gameplay_update_total_points(points):
	total_points = points
