extends Resource

class_name TokenCategory

@export var name: String
@export var ordered_tokens: Array[TokenData]
@export var spawneable: bool # says if tokens in the category can spawn (i.e. chests cant')
