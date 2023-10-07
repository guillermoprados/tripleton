extends UIPlayStateBaseScreen

class_name PlayingStateUI 

@export var alert_message:TimeoutMessage
@export var points_label:PointsCounter
@export var gold_label:PointsCounter
@export var award_points_scene: PackedScene

func current_type() -> Constants.UIPlayState:
	return Constants.UIPlayState.PLAYING

func _on_state_enter() -> void:
	pass
	
func _on_state_exit() -> void:
	pass

func _on_show_message(message:String, type:Constants.MessageType, time:float) -> void:
	alert_message.show_message(message, time)

func _on_show_floating_reward(type:Constants.RewardType, value:int, position:Vector2) -> void:
	var award_instance:AwardPoints = award_points_scene.instantiate()
	award_instance.position = position
	add_child(award_instance)
	award_instance.show_points(value)

func _on_accumulated_reward_update(type:Constants.RewardType, value:int) -> void:
	if type == Constants.RewardType.GOLD:
		gold_label.update_points(value)
	elif  type == Constants.RewardType.POINTS:
		points_label.update_points(value)
	else:
		assert("wtf??")
