extends UIPlayScreenIdBaseScreen

class_name PlayingStateUI 

@export var alert_message:TimeoutMessage
@export var points_label:PointsCounter
@export var gold_label:PointsCounter
@export var award_points_scene: PackedScene

func current_type() -> Constants.UIPlayScreenId:
	return Constants.UIPlayScreenId.PLAYING

func _on_screen_enter() -> void:
	pass
	
func _on_screen_exit() -> void:
	pass

func show_message(message:String, type:Constants.MessageType, time:float) -> void:
	alert_message.show_message(message, time)

func show_floating_reward(type:Constants.RewardType, value:int, position:Vector2) -> void:
	var award_instance:AwardPoints = award_points_scene.instantiate()
	award_instance.position = position
	add_child(award_instance)
	award_instance.show_points(value)

func accumulated_gold_update(value:int) -> void:
	print("add gold!"+str(value))
	gold_label.update_points(value)
		
func accumulated_points_update(value:int) -> void:
	print("add points!"+str(value))
	points_label.update_points(value)
	
