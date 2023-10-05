extends Node

class_name StateBase

var is_active: bool = false

signal switch_state(next_state:Constants.PlayingState)

@export var state_id:Constants.PlayingState

@export var game_manager:GameManager
@export var board: Board
@export var token_instance_provider:TokenInstanceProvider


func set_active(value):
	is_active = value
	
	if is_active:
		_on_state_entered()
	else:
		_on_state_exited()

# override in states	
func _on_state_entered():
	pass

# override in states
func _on_state_exited():
	pass
	
