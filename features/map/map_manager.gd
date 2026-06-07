class_name MapManager extends Node2D

@export var map_seed: int
@export var map_width: int = 80
@export var map_height: int = 60
@export var room_min_size: int = 3
@export var room_max_size: int = 8
@export var theme: MapTheme

@onready var map_scene: MapScene = $MapScene
@onready var pathing_manager: PathingManager = $PathingManager
@onready var generator: MapGenerator = MapGenerator.new(map_seed)

var _map: Map
var _character_positions: Dictionary[Character, Vector2i] = {}

func _ready():
	Signals.character_spawned.connect(_on_character_spawn)
	Signals.character_died.connect(_on_character_died)
	Signals.character_move.connect(_on_character_move)

func render_path(player_pos: Vector2i, target_pos: Vector2i) -> void:
	var path: Array[Vector2i] = pathing_manager.get_path_tiles(player_pos, target_pos)
	var global_path: Array[Vector2i] = []
	for coords: Vector2i in path:
		global_path.push_back(get_global_coords_from_map_coords(coords) - Vector2i(8, 8))
	pathing_manager.path = global_path

func get_global_coords_from_map_coords(coords: Vector2i) -> Vector2i:
	return map_scene.floor_layer.map_to_local(coords) * map_scene.floor_layer.scale

func create_map():
	var floor_info = FloorInfo.new()
	floor_info.floor_width = map_width
	floor_info.floor_height = map_height
	floor_info.map_theme = theme
	_map = generator.generate(map_width, map_height, room_min_size, room_max_size)
	map_scene.create(_map, map_seed, theme)
	Signals.map_generated.emit(_map, floor_info)

func _on_character_spawn(character: Character) -> void:
	var entrance := _map.find_interactable(FloorEntrance)
	var nearby_cells := _get_nearby_floor_cells(entrance, 4)
	var coords := nearby_cells[_character_positions.size() % nearby_cells.size()]
	_map.get_cell(coords).character = character
	_character_positions[character] = coords
	character.position = map_scene.floor_layer.map_to_local(coords) * map_scene.floor_layer.scale

func _on_character_died(character: Character) -> void:
	if not _character_positions.has(character):
		return
	var pos := _character_positions[character]
	_map.get_cell(pos).character = null
	_character_positions.erase(character)

func character_can_move_to(_character: Character, pos: Vector2i) -> bool:
	return _map.is_floor(pos) && !cell_is_occupied(pos)

func cell_is_occupied(cell: Vector2i) -> bool:
	# TODO also handle furniture
	for occupied_cell in _character_positions.values():
		if occupied_cell == cell:
			return true
	return false

func _on_character_move(character: Character, _start: Vector2i, end: Vector2i) -> void:
	_character_positions[character] = end
	character.position = map_scene.floor_layer.map_to_local(end) * map_scene.floor_layer.scale

func get_character_pos(character: Character) -> Vector2i:
	return _character_positions[character]

func _get_nearby_floor_cells(origin: Vector2i, count: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var offsets = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),
				   Vector2i(1,1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(-1,-1)]
	for offset in offsets:
		if result.size() >= count:
			break
		var neighbor: Vector2i = origin + offset
		if _map.is_floor(neighbor):
			result.append(neighbor)
	return result
