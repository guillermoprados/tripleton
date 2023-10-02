extends Resource

class_name TokenCombination

@export var name: String
@export var ordered_tokens: Array[TokenData]
@export var spawneable: bool # says if tokens in the combination can spawn (i.e. chests cant')
@export var prize: TokenData
