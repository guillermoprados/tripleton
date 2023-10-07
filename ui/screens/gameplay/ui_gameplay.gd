extends CanvasLayer

class_name GameplayUI

var current_state: Constants.UIPlayState = Constants.UIPlayState.NONE
var state_uis: Dictionary = {}
var active_state_ui: UIPlayStateBaseScreen

func _ready() -> void:
	for node in get_children():
		if node is UIPlayStateBaseScreen:
			state_uis[node.state_id()] = node
			node.hide()
	switch_state(current_state)
