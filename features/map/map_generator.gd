class_name MapGenerator extends RefCounted

const ENTRANCE_SCENE = preload("res://features/entities/floor_entrance/floor_entrance.tscn")
const EXIT_SCENE     = preload("res://features/entities/floor_exit/floor_exit.tscn")
const CHEST_SCENE    = preload("res://features/entities/treasure_chest/treasure_chest.tscn")

const STARTING_ROOM := Rect2i(0, 0, 5, 5)

class Exit:
	var pos: Vector2i
	var dir: Vector2i
	var connected: bool = false

class Room:
	var rect: Rect2i
	var exits: Array = []

var _rng: RandomNumberGenerator
var _min_room_w: int
var _min_room_h: int
var _max_room_w: int
var _max_room_h: int

func _init(map_seed: int) -> void:
	_rng = RandomNumberGenerator.new()
	_rng.seed = map_seed

func generate(min_room_w: int, min_room_h: int, max_room_w: int, max_room_h: int, num_rooms: int) -> Map:
	_min_room_w = min_room_w
	_min_room_h = min_room_h
	_max_room_w = max_room_w
	_max_room_h = max_room_h

	var map := Map.new()

	var starting_room := _create_starting_room()
	_fill_room(starting_room, map)

	var exit_queue: Array = starting_room.exits.duplicate()
	var rooms_placed := 1  # starting room counts

	while rooms_placed < num_rooms:
		if exit_queue.is_empty():
			break
		var idx := _rng.randi() % exit_queue.size()
		var queue_exit: Exit = exit_queue[idx]
		var new_room: Room = _try_attach(queue_exit, map)
		if new_room:
			_fill_room(new_room, map)
			exit_queue.remove_at(idx)
			for e in new_room.exits:
				if not e.connected:
					exit_queue.append(e)
			rooms_placed += 1

	_compute_bounds(map)
	_generate_walls(map)
	_place_interactables(map)
	return map

# ── Room construction ─────────────────────────────────────────────────────────

func _create_starting_room() -> Room:
	var room := Room.new()
	room.rect = STARTING_ROOM
	room.exits = [
		_exit_at(Vector2i(1, -1),  Vector2i( 0, -1)),  # N: tiles (1,-1),(2,-1)
		_exit_at(Vector2i(1,  5),  Vector2i( 0,  1)),  # S: tiles (1,5),(2,5)
		_exit_at(Vector2i(5,  1),  Vector2i( 1,  0)),  # E: tiles (5,1),(5,2)
		_exit_at(Vector2i(-1, 1),  Vector2i(-1,  0)),  # W: tiles (-1,1),(-1,2)
	]
	return room

func _try_attach(queue_exit: Exit, map: Map) -> Room:
	var dir := queue_exit.dir
	var ex  := queue_exit.pos.x
	var ey  := queue_exit.pos.y

	var rw := _rng.randi_range(_min_room_w, _max_room_w)
	var rh := _rng.randi_range(_min_room_h, _max_room_h)
	var nx: int
	var ny: int

	if dir == Vector2i(0,  1):   # exit points south → room below
		ny = ey + 1
		nx = ex - _rng.randi_range(0, rw - 2)
	elif dir == Vector2i(0, -1): # exit points north → room above
		ny = ey - rh
		nx = ex - _rng.randi_range(0, rw - 2)
	elif dir == Vector2i(1,  0): # exit points east → room right
		nx = ex + 1
		ny = ey - _rng.randi_range(0, rh - 2)
	else:                         # exit points west → room left
		nx = ex - rw
		ny = ey - _rng.randi_range(0, rh - 2)

	# Reject if any rect tile already has floor
	for y in range(ny, ny + rh):
		for x in range(nx, nx + rw):
			if map.cells.has(Vector2i(x, y)):
				return null

	var room := Room.new()
	room.rect = Rect2i(nx, ny, rw, rh)

	var entry := _exit_at(queue_exit.pos, -dir)
	entry.connected = true
	room.exits.append(entry)

	_add_exits(room, -dir, _rng.randi_range(0, 3))
	return room

func _add_exits(room: Room, entry_dir: Vector2i, count: int) -> void:
	var available: Array = [Vector2i(0,-1), Vector2i(0,1), Vector2i(1,0), Vector2i(-1,0)]
	available = available.filter(func(d: Vector2i) -> bool: return d != entry_dir)
	for _i in count:
		if available.is_empty():
			break
		var idx := _rng.randi() % available.size()
		room.exits.append(_make_exit(room.rect, available[idx]))
		available.remove_at(idx)

func _make_exit(rect: Rect2i, dir: Vector2i) -> Exit:
	var pos: Vector2i
	if dir == Vector2i(0, -1):
		pos = Vector2i(rect.position.x + _rng.randi_range(0, rect.size.x - 2), rect.position.y - 1)
	elif dir == Vector2i(0, 1):
		pos = Vector2i(rect.position.x + _rng.randi_range(0, rect.size.x - 2), rect.end.y)
	elif dir == Vector2i(1, 0):
		pos = Vector2i(rect.end.x, rect.position.y + _rng.randi_range(0, rect.size.y - 2))
	else:
		pos = Vector2i(rect.position.x - 1, rect.position.y + _rng.randi_range(0, rect.size.y - 2))
	return _exit_at(pos, dir)

func _exit_at(pos: Vector2i, dir: Vector2i) -> Exit:
	var e := Exit.new()
	e.pos = pos
	e.dir = dir
	return e

# N/S exits are 2 tiles wide (horizontal pair); E/W are 2 tiles tall (vertical pair).
func _side_step(dir: Vector2i) -> Vector2i:
	return Vector2i(0, 1) if dir.x != 0 else Vector2i(1, 0)

# ── Floor filling ─────────────────────────────────────────────────────────────

func _fill_room(room: Room, map: Map) -> void:
	_fill_rect(room.rect, map)
	for e in room.exits:
		_set_floor(e.pos, map)
		_set_floor(e.pos + _side_step(e.dir), map)

func _fill_rect(rect: Rect2i, map: Map) -> void:
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var cell := Cell.new()
			cell.terrain = Cell.Terrain.FLOOR
			map.cells[Vector2i(x, y)] = cell

func _set_floor(pos: Vector2i, map: Map) -> void:
	var cell: Cell = map.cells.get(pos, null)
	if cell == null:
		cell = Cell.new()
		map.cells[pos] = cell
	cell.terrain = Cell.Terrain.FLOOR

# ── Walls & bounds ────────────────────────────────────────────────────────────

func _compute_bounds(map: Map) -> void:
	if map.cells.is_empty():
		return
	var first: Vector2i = map.cells.keys()[0]
	var min_x := first.x
	var min_y := first.y
	var max_x := first.x
	var max_y := first.y
	for pos in map.cells:
		min_x = mini(min_x, pos.x)
		min_y = mini(min_y, pos.y)
		max_x = maxi(max_x, pos.x)
		max_y = maxi(max_y, pos.y)
	map.bounds = Rect2i(min_x - 1, min_y - 1, max_x - min_x + 3, max_y - min_y + 3)

func _generate_walls(map: Map) -> void:
	var offsets := [
		Vector2i(0,-1), Vector2i(0,1), Vector2i(-1,0), Vector2i(1,0),
		Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(1,1)
	]
	for pos in map.cells.keys():
		for offset in offsets:
			var neighbor: Vector2i = pos + offset
			if not map.cells.has(neighbor) and map.bounds.has_point(neighbor):
				var cell := Cell.new()
				cell.terrain = Cell.Terrain.WALL
				map.cells[neighbor] = cell

# ── Interactables ─────────────────────────────────────────────────────────────

func _place_interactables(map: Map) -> void:
	var positions := map.get_floor_positions()
	var used: Dictionary[Vector2i, bool] = {}

	var entrance_pos := STARTING_ROOM.get_center()
	used[entrance_pos] = true
	map.cells[entrance_pos].interactable = ENTRANCE_SCENE.instantiate()

	var exit_pos := _pick_unused(positions, used)
	used[exit_pos] = true
	map.cells[exit_pos].interactable = EXIT_SCENE.instantiate()

	for _i in 3:
		var chest_pos := _pick_unused(positions, used)
		used[chest_pos] = true
		map.cells[chest_pos].interactable = CHEST_SCENE.instantiate()

func _pick_unused(positions: Array, used: Dictionary[Vector2i, bool]) -> Vector2i:
	var pos: Vector2i = positions[_rng.randi_range(0, positions.size() - 1)]
	while used.has(pos):
		pos = positions[_rng.randi_range(0, positions.size() - 1)]
	return pos
