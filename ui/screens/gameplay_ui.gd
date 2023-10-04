extends Control

var points_label:PointsCounter
var gold_label:PointsCounter

var alert_message:Label

@export var award_points_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	points_label = $PointsCounter
	gold_label = $GoldCounter
	alert_message = $AlertMessage
	reset()

func reset():
	points_label.reset()
	alert_message.hide()
	$AlertMessageTimer.timeout.connect(hide_message)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_message():
	alert_message.hide()

func _on_gameplay_show_message(message, color_name, time):
	var theme_color = alert_message.get_theme().get_color(color_name, "Label")
	if theme_color:  # Check if the color is defined in the theme
		alert_message.add_theme_color_override("font_color", theme_color)
	alert_message.text = message  # Set the message text
	alert_message.show()  # Show the message label
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
