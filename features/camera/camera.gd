extends Camera2D

const ZOOM_SPEED := 0.25
const ZOOM_MIN := Vector2(1, 1)
const ZOOM_MAX := Vector2(8.0, 8.0)

var _dragging := false
var _drag_start_mouse := Vector2.ZERO
var _drag_start_camera := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			match event.button_index:
					MOUSE_BUTTON_WHEEL_UP:
							zoom = clamp(zoom + Vector2(ZOOM_SPEED, ZOOM_SPEED), ZOOM_MIN, ZOOM_MAX)
					MOUSE_BUTTON_WHEEL_DOWN:
							zoom = clamp(zoom - Vector2(ZOOM_SPEED, ZOOM_SPEED), ZOOM_MIN, ZOOM_MAX)
					MOUSE_BUTTON_LEFT:
							_dragging = event.pressed
							if _dragging:
									_drag_start_mouse = get_viewport().get_mouse_position()
									_drag_start_camera = global_position

	if event is InputEventMouseMotion and _dragging:
			var delta := get_viewport().get_mouse_position() - _drag_start_mouse
			global_position = _drag_start_camera - delta / zoom
