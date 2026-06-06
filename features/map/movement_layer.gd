class_name MovementLayer extends Node2D

var path: Array[Vector2i] = []:
	set(value):
		path = value
		queue_redraw()

func _draw() -> void:
	var rect_color = Color.MEDIUM_ORCHID
	for coords: Vector2i in path:
		var movement_rect: Rect2 = Rect2(coords, Vector2i(16, 16))
		draw_rect(movement_rect, rect_color)
