extends Resource

class_name TokenProvider

@export var token_scene: PackedScene
@export var tokens_config: TokensConfig

func get_token_instance():
	var token_instance = token_scene.instantiate()
	token_instance.set_data(tokens_config.tokens[0])
	return token_instance
