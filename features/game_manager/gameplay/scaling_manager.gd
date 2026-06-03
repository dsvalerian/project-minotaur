class_name ScalingManager extends RefCounted

@export var FLOOR_BASE_SIZE: int = 64
@export var FLOOR_SIZE_SCALE_FACTOR: int = 8

func get_floor_info(floor_num: int) -> FloorInfo:
	var floor_info: FloorInfo = FloorInfo.new()
	floor_info.floor_size = get_floor_size(floor_num)
	floor_info.room_size_range = get_room_size(floor_num)
	return floor_info

func get_floor_size(floor_num: int) -> Vector2i:
	var x = FLOOR_BASE_SIZE + (floor_num * FLOOR_SIZE_SCALE_FACTOR)
	var y = FLOOR_BASE_SIZE + (floor_num * FLOOR_SIZE_SCALE_FACTOR)
	return Vector2i(x, y)

func get_room_size(_floor_num: int) -> Vector2i:
	# TODO
	return Vector2i(8, 8)

func get_theme(_floor_num: int) -> MapTheme:
	var floor_theme: MapTheme = load("res://features/map/themes/dungeon/dungeon_theme.tres")
	return floor_theme
