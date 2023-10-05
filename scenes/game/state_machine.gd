extends Node

class_name StateMachine

var current_state: Constants.PlayingState = Constants.PlayingState.INTRO
var states: Dictionary = {}
var active_state: StateBase

func _ready():
	for node in get_children():
		if node is StateBase:
			states[node.state_id] = node
			node.switch_state.connect(self.switch_state)
			node.set_process(false)
	switch_state(current_state)

func _process(delta):
	if active_state:
		active_state._process(delta)

func switch_state(new_state:Constants.PlayingState):
	if active_state:
		print("leaving state: "+ __state_name(active_state.state_id))
		active_state._on_state_exited()
		active_state.set_process(false)
	
	active_state = states[new_state]
	
	if active_state:
		print("entering state: "+ __state_name(active_state.state_id))
		active_state._on_state_entered()
		active_state.set_process(true)

func __state_name(state:Constants.PlayingState) -> String:
	match state:
		Constants.PlayingState.NONE:
			return "None"
		Constants.PlayingState.INTRO:
			return "IntroState"
		Constants.PlayingState.PLAYER:
			return "UserPlayState"
		Constants.PlayingState.ENEMIES:
			return "EnemiesState"
		Constants.PlayingState.PAUSED:
			return "PausedState"
		_:
			return "I DONT KNOW"
