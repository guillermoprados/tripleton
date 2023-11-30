extends Area2D

class_name BoardCell

signal cell_entered(index:Vector2)
signal cell_exited(index:Vector2)
signal cell_selected(index:Vector2)

var board_cell_position:Vector2

@export var base_color : Color = Color(0.5, 0.5, 0.5, 1)
@export var highlihgt_none : Color = Color(1, 1, 1, 0)
@export var highlight_valid : Color = Color(0.5, 1, 0.5, 1)
@export var highlight_invalid : Color = Color(1, 0.5, 0.5, 1)
@export var highlight_wasted : Color = Color(1, 0.5, 0.5, 1)
@export var highlight_combination : Color = Color(0.5, 0.5, 1, 1)

var __highlight : Constants.CellHighlight
var highlight: Constants.CellHighlight:
	get:
		return __highlight

var __is_mobile:bool
var __pressed_at:float

func _ready() -> void:
	#probably move this
	__is_mobile = OS.get_name() == "Android" or OS.get_name() == "iOS"
	$HighLightColor.modulate = highlihgt_none

func __just_for_test_click_cell() -> void:
	cell_selected.emit(board_cell_position)
	
func _on_mouse_entered() -> void:
	__pressed_at = Time.get_unix_time_from_system()
	cell_entered.emit(board_cell_position)
	
func _on_mouse_exited() -> void:
	cell_exited.emit(board_cell_position)
				
func _on_input_event(viewport:Viewport, event:InputEvent, shape_idx:int) -> void:
	if __is_mobile:
		__process_mobile_events(event)	
	elif event is InputEventMouseButton and event.is_pressed():
		# Check if it's a left mouse button click (button_index 1) if needed
		if event.button_index == MOUSE_BUTTON_LEFT:
			cell_selected.emit(board_cell_position)
			
func __process_mobile_events(event:InputEvent) -> void:
	
	if event is InputEventScreenTouch:
		var input_event : InputEventScreenTouch = event as InputEventScreenTouch
		if input_event.index == 0:
			if input_event.is_pressed():
				__pressed_at = Time.get_unix_time_from_system()
			if input_event.is_released():
				var current_time := Time.get_unix_time_from_system()
				if current_time - __pressed_at < Constants.HOLD_TIME_TO_CANCEL_PRESS:
					cell_selected.emit(board_cell_position)
			
func clear_highlight() -> void:
	set_highlight(Constants.CellHighlight.NONE)
	
func set_highlight(mode: Constants.CellHighlight) -> void:
	__highlight = mode
	match mode:
		Constants.CellHighlight.NONE:
			$HighLightColor.modulate = highlihgt_none
		Constants.CellHighlight.VALID:
			$HighLightColor.modulate = highlight_valid
		Constants.CellHighlight.INVALID:
			$HighLightColor.modulate = highlight_invalid
		Constants.CellHighlight.WASTED:
			$HighLightColor.modulate = highlight_wasted
		Constants.CellHighlight.COMBINATION:
			$HighLightColor.modulate = highlight_combination
