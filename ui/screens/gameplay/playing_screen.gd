extends UIPlayScreenIdBaseScreen

class_name PlayingStateUI 

@export var alert_message:TimeoutMessage
@export var points_label:PointsCounter
@export var gold_label:PointsCounter
@export var award_points_scene: PackedScene
@export var dinasty_label: Label
@export var dinasty_progress: ProgressBar

func screen_id() -> Constants.UIPlayScreenId:
	return Constants.UIPlayScreenId.PLAYING

func _on_screen_enter() -> void:
	pass
	
func _on_screen_exit() -> void:
	pass

func show_message(message:String, type:Constants.MessageType, time:float) -> void:
	alert_message.show_message(message, time)

func show_floating_reward(type:Constants.RewardType, value:int, position:Vector2) -> void:
	var award_instance:AwardPoints = award_points_scene.instantiate()
	add_child(award_instance)
	award_instance.position = position
	award_instance.position.y -= Constants.CELL_SIZE.y / 4
	award_instance.show_points(value)

func accumulated_gold_update(value:int) -> void:
	gold_label.update_points(value)
		
func accumulated_points_update(value:int) -> void:
	points_label.update_points(value)
	
func set_dinasty(name:String, max_points:int) -> void:
	dinasty_progress.value = 0
	dinasty_label.text = name
	dinasty_progress.max_value = max_points
	
func set_dinasty_progress(value:int) -> void:
	dinasty_progress.value = value
