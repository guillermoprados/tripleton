extends CanvasLayer

var points_label:TotalPoints
var gold_label:TotalPoints

var message_label:Label

@export var award_points_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	points_label = $Points
	gold_label = $Gold
	message_label = $Message
	reset()

func reset():
	points_label.reset()
	message_label.hide()
	$MessageTimer.timeout.connect(hide_message)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_message():
	message_label.hide()

func _on_gameplay_show_message(message, color_name, time):
	var theme_color = message_label.get_theme().get_color(color_name, "Label")
	if theme_color:  # Check if the color is defined in the theme
		message_label.add_theme_color_override("font_color", theme_color)
	message_label.text = message  # Set the message text
	message_label.show()  # Show the message label
	$MessageTimer.start(time)  # Start the timer


func _on_gameplay_show_floating_reward(type, value, position):
	var award_instance:AwardPoints = award_points_scene.instantiate()
	award_instance.position = position
	add_child(award_instance)
	award_instance.show_points(value)	

func _on_gameplay_accumulated_reward_update(type, value):
	if type == Constants.RewardType.GOLD:
		gold_label.update_points(value)
	elif  type == Constants.RewardType.POINTS:
		points_label.update_points(value)
	else:
		assert("wtf??")
