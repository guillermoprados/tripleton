extends StateBase

class_name StateIntro

func _on_state_entered() -> void:
	game_manager.gameplay_ui.switch_ui(Constants.UIPlayScreenId.INTRO)

# override in states
func _on_state_exited() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	switch_state.emit(Constants.PlayingState.PLAYER)
