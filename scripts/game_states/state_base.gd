extends Node

class_name StateBase

#used by states to require the machine to switch states
signal switch_state(next_state:Constants.PlayingState)
signal state_finished(id:Constants.PlayingState)

var id:Constants.PlayingState:
	get:
		return state_id()

func state_id() -> Constants.PlayingState:
	return Constants.PlayingState.NONE

var game_manager:GameManager
var board: Board

func enable_state() -> void:
	set_process(true)
	_on_state_entered()

func disable_state() -> void:
	_on_state_exited()
	set_process(false)

# override in states	
func _on_state_entered() -> void:
	pass

# override in states
func _on_state_exited() -> void:
	pass

