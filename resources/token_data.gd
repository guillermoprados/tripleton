extends Resource

class_name TokenData

@export var id: String
@export var sprite_scene: PackedScene
@export var points: int = 0
@export var gold: int = 0
@export var is_chest: bool
@export var prizes: Array[PoolItem] = [] #should only be used by chests
@export var is_prize: bool
