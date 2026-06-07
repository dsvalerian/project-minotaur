class_name PathingManager extends Node2D

var tile_size: Vector2i = Vector2i(16, 16)
var rect_color: Color = Color.MEDIUM_ORCHID
var _pathfinder: AStarGrid2D = AStarGrid2D.new()
var floor_info: FloorInfo
var map: Map

var path: Array[Vector2i] = []:
	set(value):
		path = value
		queue_redraw()

func _ready() -> void:
	Signals.map_generated.connect(_on_map_generation)

func _on_map_generation(new_map: Map, new_floor_info: FloorInfo):
	map = new_map
	floor_info = new_floor_info
	tile_size = floor_info.map_theme.tileset.tile_size
	update()

func update() -> void:
	_pathfinder.region = Rect2i(-1, -1, floor_info.floor_width + 1, floor_info.floor_height + 1)
	_pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_pathfinder.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_pathfinder.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_pathfinder.update()
	for wall_coords: Vector2i in map.get_wall_positions():
		_pathfinder.set_point_solid(wall_coords, true)

func get_path_tiles(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if (!_pathfinder.is_in_bounds(end.x, end.y) || _pathfinder.is_point_solid(end)):
		return []
	else:
		return _pathfinder.get_id_path(start, end)

func _draw() -> void:
	for coords: Vector2i in path:
		var movement_rect: Rect2 = Rect2(coords, tile_size)
		draw_rect(movement_rect, rect_color)
