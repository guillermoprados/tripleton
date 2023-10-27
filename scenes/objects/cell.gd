extends Area2D

class_name BoardCell

signal cell_entered(index:Vector2)
signal cell_exited(index:Vector2)
signal cell_selected(index:Vector2)

var cell_index:Vector2

@export var base_color : Color = Color(0.5, 0.5, 0.5, 1)
@export var highlihgt_none : Color = Color(1, 1, 1, 0)
@export var highlight_valid : Color = Color(0.5, 1, 0.5, 1)
@export var highlight_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var highlight_warning : Color = Color(1, 0.5, 0.5, 1)
@export var highlight_combination : Color = Color(0.5, 0.5, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# adjust_size(Constants.CELL_SIZE)
	$HighLightColor.color = highlihgt_none
	
func _on_mouse_entered() -> void:
	cell_entered.emit(cell_index)

func _on_mouse_exited() -> void:
	cell_exited.emit(cell_index)
				
func _on_input_event(viewport:Viewport, event:InputEvent, shape_idx:int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		# Check if it's a left mouse button click (button_index 1) if needed
		if event.button_index == MOUSE_BUTTON_LEFT:
			cell_selected.emit(cell_index)
	elif event is InputEventScreenTouch and event.pressed:
		pass
		# Handle touch events here
		# event.index is the touch point index (useful for multitouch)
		# event.position is the screen position where the touch occurred
		# event.global_position is the global position on the screen
		# You can adapt your touch handling logic as needed
	# Add more conditions for other types of input events if necessary
	
func clear_highlight() -> void:
	highlight(Constants.CellHighlight.NONE)
	
func highlight(mode: Constants.CellHighlight) -> void:
	match mode:
		Constants.CellHighlight.NONE:
			$HighLightColor.color = highlihgt_none
		Constants.CellHighlight.VALID:
			$HighLightColor.color = highlight_valid
		Constants.CellHighlight.INVALID:
			$HighLightColor.color = highlight_invalid
		Constants.CellHighlight.WARNING:
			$HighLightColor.color = highlight_warning
		Constants.CellHighlight.COMBINATION:
			$HighLightColor.color = highlight_combination
