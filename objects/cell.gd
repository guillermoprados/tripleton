extends Area2D
signal cell_entered(index:Vector2)
signal cell_exited(index:Vector2)
signal cell_selected(index:Vector2)

var cell_index:Vector2

@export var empty_color: Color
@export var hover_color: Color
@export var select_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackColor.color = empty_color
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	$BackColor.color = hover_color
	cell_entered.emit(cell_index)

func _on_mouse_exited():
	$BackColor.color = empty_color
	cell_exited.emit(cell_index)
				
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		# Check if it's a left mouse button click (button_index 1) if needed
		if event.button_index == MOUSE_BUTTON_LEFT:
			$BackColor.color = select_color
			cell_selected.emit(cell_index)
	elif event is InputEventScreenTouch and event.pressed:
		pass
		# Handle touch events here
		# event.index is the touch point index (useful for multitouch)
		# event.position is the screen position where the touch occurred
		# event.global_position is the global position on the screen
		# You can adapt your touch handling logic as needed
	# Add more conditions for other types of input events if necessary

func size() -> Vector2:
	return $BackColor.get_size()
