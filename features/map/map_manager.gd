extends Node2D
class_name MapManager

@onready var map_floor = $MapFloor
@onready var room_floor = $RoomFloor

func change_floor(x_length: int, y_length: int):
	var rng_seed = "sugma"
	map_floor.generate(x_length, y_length, rng_seed)
	room_floor.set_room(Vector2i(0,0), "ENTRANCE")
	room_floor.set_room(Vector2i(x_length-1, y_length-1), "EXIT")
