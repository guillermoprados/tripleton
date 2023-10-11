extends Area2D

class_name BoardCell

signal cell_entered(index:Vector2)
signal cell_exited(index:Vector2)
signal cell_selected(index:Vector2)

var cell_index:Vector2

@export var base_color : Color = Color(0.5, 0.5, 0.5, 1)
@export var transparent_color : Color = Color(1, 1, 1, 0)
@export var highlight_strong_valid : Color = Color(0.5, 1, 0.5, 1)
@export var highlight_strong_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var highlight_light_valid : Color = Color(0.75, 1, 0.75, 1)
@export var highlight_light_invalid : Color = Color(1, 0.75, 0.75, 1)
@export var highlight_combination : Color = Color(0.5, 0.5, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_size(Constants.CELL_SIZE)
	$BackColor.color = base_color
	$HighLightColor.color = transparent_color
	
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

func adjust_size(new_size: Vector2) -> void:
	self.scale = new_size / Constants.CELL_SPRITE_SIZE
	
func highlight(mode: Constants.HighlightMode, valid: bool) -> void:
	match mode:
		Constants.HighlightMode.NONE:
			$HighLightColor.color = transparent_color
		Constants.HighlightMode.HOVER:
			$HighLightColor.color = highlight_strong_valid if valid else highlight_strong_invalid
		Constants.HighlightMode.SAME_LINE:
			$HighLightColor.color = highlight_light_valid if valid else highlight_light_invalid
		Constants.HighlightMode.COMBINATION:
			$HighLightColor.color = highlight_combination
