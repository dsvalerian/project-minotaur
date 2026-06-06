extends Camera2D

const MOVE_SPEED := 15
const ZOOM_SPEED := 0.25
const ZOOM_MIN := Vector2(1, 1)
const ZOOM_MAX := Vector2(8.0, 8.0)

var target_zoom: Vector2 = ZOOM_MIN

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("camera_up"):
		global_position = global_position - Vector2(0, MOVE_SPEED) / zoom
	if Input.is_action_pressed("camera_down"):
		global_position = global_position + Vector2(0, MOVE_SPEED) / zoom
	if Input.is_action_pressed("camera_left"):
		global_position = global_position - Vector2(MOVE_SPEED, 0) / zoom
	if Input.is_action_pressed("camera_right"):
		global_position = global_position + Vector2(MOVE_SPEED, 0) / zoom
	zoom = target_zoom

func _input(event: InputEvent):
	if event is InputEventMouseButton:
			match event.button_index:
					MOUSE_BUTTON_WHEEL_UP:
							target_zoom = clamp(zoom + Vector2(ZOOM_SPEED, ZOOM_SPEED), ZOOM_MIN, ZOOM_MAX)
					MOUSE_BUTTON_WHEEL_DOWN:
							target_zoom = clamp(zoom - Vector2(ZOOM_SPEED, ZOOM_SPEED), ZOOM_MIN, ZOOM_MAX)
