extends Node

class_name StateBase

var is_active: bool = false

#used by states to require the machine to switch states
signal switch_state(next_state:Constants.PlayingState)

@export var state_id:Constants.PlayingState

@export var game_manager:GameManager
@export var board: Board

func set_active(value:bool) -> void:
	is_active = value
	
	if is_active:
		_on_state_entered()
		set_process(true)
	else:
		_on_state_exited()
		set_process(false)

# override in states	
func _on_state_entered() -> void:
	pass

# override in states
func _on_state_exited() -> void:
	pass

