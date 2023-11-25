extends Node

class_name EnemiesManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func find_stucked_enemies_cells(cell_tokens_ids:Array) -> Array[Vector2]:
	var stucked_enemies_cells :Array[Vector2] = []
	return stucked_enemies_cells
