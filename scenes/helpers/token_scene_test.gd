extends Node2D

@export var token_id:String
@export var token_test:BoardToken
@export var token_status:Constants.TokenStatus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	token_test.set_data(token_id, token_status)
	
func _process(delta:float) -> void:
	if token_test.current_status != token_status:
		token_test.set_status(token_status)

