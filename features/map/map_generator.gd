class_name MapGenerator extends RefCounted

const ENTRANCE_SCENE = preload("res://features/entities/floor_entrance/floor_entrance.tscn")
const EXIT_SCENE = preload("res://features/entities/floor_exit/floor_exit.tscn")
const CHEST_SCENE = preload("res://features/entities/treasure_chest/treasure_chest.tscn")

var _rng: RandomNumberGenerator
var _room_min_size: int
var _room_max_size: int

func _init(map_seed: int):
	_rng = RandomNumberGenerator.new()
	_rng.seed = map_seed

func generate(map_width: int, map_height: int, room_min_size: int, room_max_size: int) -> Map:
	_room_min_size = room_min_size
	_room_max_size = room_max_size

	var map := Map.new()
	map.bounds = Rect2i(0, 0, map_width, map_height)

	var rooms := _place_rooms(map_width, map_height)
	for room in rooms:
		_fill_rect(room, map)

	_generate_walls(map, map_width, map_height)
	_place_interactables(map)
	return map

func _place_rooms(map_w: int, map_h: int) -> Array[Rect2i]:
	var rooms: Array[Rect2i] = []

	# Seed room near top-left
	var w = _rng.randi_range(_room_min_size, _room_max_size)
	var h = _rng.randi_range(_room_min_size, _room_max_size)
	rooms.append(Rect2i(0, 0, w, h))

	for _attempt in 500:
		var base: Rect2i = rooms[_rng.randi_range(0, rooms.size() - 1)]
		var nw = _rng.randi_range(_room_min_size, _room_max_size)
		var nh = _rng.randi_range(_room_min_size, _room_max_size)
		var nx: int
		var ny: int

		match _rng.randi_range(0, 3):
			0:  # north
				nx = _rng.randi_range(base.position.x - nw + 1, base.end.x - 1)
				ny = base.position.y - nh
			1:  # east
				nx = base.end.x
				ny = _rng.randi_range(base.position.y - nh + 1, base.end.y - 1)
			2:  # south
				nx = _rng.randi_range(base.position.x - nw + 1, base.end.x - 1)
				ny = base.end.y
			_:  # west
				nx = base.position.x - nw
				ny = _rng.randi_range(base.position.y - nh + 1, base.end.y - 1)

		var candidate = Rect2i(nx, ny, nw, nh)

		if nx < 0 or ny < 0 or candidate.end.x > map_w or candidate.end.y > map_h:
			continue

		var valid = true
		for r in rooms:
			if _rooms_conflict(r, candidate):
				valid = false
				break

		if valid:
			rooms.append(candidate)

	return rooms

# Overlap = bad. Exactly 1 cell apart (axis or diagonal) = bad. Touching or 2+ apart = OK.
# p1 catches gap=0 (touching). p2 catches gap=0 and gap=1. Difference = exactly gap=1 -> reject.
func _rooms_conflict(a: Rect2i, b: Rect2i) -> bool:
	if a.intersects(b):
		return true
	var p1 = Rect2i(a.position - Vector2i(1, 1), a.size + Vector2i(2, 2))
	var p2 = Rect2i(a.position - Vector2i(2, 2), a.size + Vector2i(4, 4))
	return p2.intersects(b) and not p1.intersects(b)

func _fill_rect(rect: Rect2i, map: Map) -> void:
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var pos := Vector2i(x, y)
			var cell := Cell.new()
			cell.terrain = Cell.Terrain.FLOOR
			map.cells[pos] = cell

func _generate_walls(map: Map, map_w: int, map_h: int) -> void:
	var offsets = [
		Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0),
		Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)
	]
	var wall_bounds := Rect2i(-1, -1, map_w + 2, map_h + 2)
	var floor_positions := map.cells.keys()
	for pos in floor_positions:
		for offset in offsets:
			var neighbor: Vector2i = pos + offset
			if not map.cells.has(neighbor) and wall_bounds.has_point(neighbor):
				var cell := Cell.new()
				cell.terrain = Cell.Terrain.WALL
				map.cells[neighbor] = cell

func _place_interactables(map: Map) -> void:
	var positions := map.get_floor_positions()
	var used: Dictionary[Vector2i, bool] = {}

	var entrance_pos := _pick_unused(positions, used)
	used[entrance_pos] = true
	map.cells[entrance_pos].interactable = ENTRANCE_SCENE.instantiate()

	var exit_pos := _pick_unused(positions, used)
	used[exit_pos] = true
	map.cells[exit_pos].interactable = EXIT_SCENE.instantiate()

	for i in 3:
		var chest_pos := _pick_unused(positions, used)
		used[chest_pos] = true
		map.cells[chest_pos].interactable = CHEST_SCENE.instantiate()

func _pick_unused(positions: Array, used: Dictionary[Vector2i, bool]) -> Vector2i:
	var pos: Vector2i = positions[_rng.randi_range(0, positions.size() - 1)]
	while used.has(pos):
		pos = positions[_rng.randi_range(0, positions.size() - 1)]
	return pos
