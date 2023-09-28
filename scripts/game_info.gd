extends Node

class_name GameInfo

@export var level_config:LevelConfig

var rows: int
var columns: int
var points: int


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(level_config != null, "Please set the level config")
	self.rows = level_config.rows
	self.columns = level_config.columns
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next_difficulty() -> GameDifficulty:
	return level_config.difficulties[0] 
