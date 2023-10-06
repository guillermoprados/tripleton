extends StateBase

class_name StateEnemiesTurn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	
	var enemies:Dictionary = board.get_tokens_of_type(Constants.TokenType.ENEMY)
	for key in enemies:
		print(enemies[key].id + " at "+str(key))
	
	finish_enemies_turn()
	
func finish_enemies_turn() -> void:
	switch_state.emit(Constants.PlayingState.PLAYER)
