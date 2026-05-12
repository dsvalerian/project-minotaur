extends TileMapLayer

func set_room(coords: Vector2i, key: String):
	if (key == "ENTRANCE"):
		set_cell(coords, 0, Vector2i(0,0), 1)
	elif (key == "EXIT"):
		set_cell(coords, 0, Vector2i(0,0), 2)
