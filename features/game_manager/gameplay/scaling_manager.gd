class_name ScalingManager extends RefCounted

@export var BASE_ROOM_MIN_WIDTH: int = 5
@export var BASE_ROOM_MIN_HEIGHT: int = 5
@export var BASE_ROOM_MAX_WIDTH: int = 5
@export var BASE_ROOM_MAX_HEIGHT: int = 5
@export var BASE_NUM_ROOMS: int = 3

@export var ROOM_WIDTH_MIN_SCALING: int = 0
@export var ROOM_HEIGHT_MIN_SCALING: int = 0
@export var ROOM_WIDTH_MAX_SCALING: int = 0
@export var ROOM_HEIGHT_MAX_SCALING: int = 0
@export var NUM_ROOMS_SCALING: int = 2

func get_floor_info(floor_num: int) -> FloorInfo:
	var floor_info: FloorInfo = FloorInfo.new()
	floor_info.min_room_width = BASE_ROOM_MIN_WIDTH + (floor_num * ROOM_WIDTH_MIN_SCALING)
	floor_info.min_room_height = BASE_ROOM_MIN_HEIGHT + (floor_num * ROOM_HEIGHT_MIN_SCALING)
	floor_info.max_room_width = BASE_ROOM_MAX_WIDTH + (floor_num * ROOM_WIDTH_MAX_SCALING)
	floor_info.max_room_height = BASE_ROOM_MAX_HEIGHT + (floor_num * ROOM_HEIGHT_MAX_SCALING)
	floor_info.num_rooms = BASE_NUM_ROOMS + (floor_num * NUM_ROOMS_SCALING)
	floor_info.map_theme = get_theme(floor_num)
	return floor_info

func get_theme(_floor_num: int) -> MapTheme:
	var floor_theme: MapTheme = load("res://features/map/themes/dungeon/dungeon_theme.tres")
	return floor_theme
