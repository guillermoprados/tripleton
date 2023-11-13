extends Node

class_name StateMachine

var states: Dictionary = {}
var active_state: StateBase

@export var game_manager:GameManager
@export var board: Board
@export var print_debug: bool = false

var current_state:Constants.PlayingState:
	get:
		return active_state.id
	
func _ready() -> void:
	assert(board, "please assign the board")
	assert(game_manager, "please assign the game_manager")
	for node in get_children():
		if node is StateBase:
			states[node.id] = node
			node.switch_state.connect(self.switch_state)
			node.state_finished.connect(self.handle_state_finished)
			node.game_manager = game_manager
			node.board = board
			node.set_process(false)
	switch_state(Constants.PlayingState.INTRO)

func switch_state(new_state:Constants.PlayingState)-> void:
	if active_state:
		if print_debug:
			print(" x state: "+ __state_name(active_state.id))
		active_state.disable_state()
	
	active_state = states[new_state]
	
	if active_state:
		if print_debug:
			print(" > state: "+ __state_name(active_state.id))
		active_state.enable_state()

func handle_state_finished(state:Constants.PlayingState) -> void:
	match state:
		Constants.PlayingState.INTRO:
			switch_state(Constants.PlayingState.PLAYER)
		Constants.PlayingState.PLAYER:
			switch_state(Constants.PlayingState.ENEMIES)
		Constants.PlayingState.ENEMIES:
			switch_state(Constants.PlayingState.CHECK)
		Constants.PlayingState.CHECK:
			switch_state(Constants.PlayingState.PLAYER)
		_:
			assert( false, "cannot handle that state "+__state_name(state))
			
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
		Constants.PlayingState.CHECK:
			return "CheckState"
		Constants.PlayingState.GAME_OVER:
			return "GameOverState"
		_:
			assert(false, "trying to change to state that I don't know")
			return "I don't know"
