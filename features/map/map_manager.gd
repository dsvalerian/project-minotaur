class_name MapManager extends Node2D

@export var map_seed: int
@export var map_width: int = 80
@export var map_height: int = 60
@export var room_min_size: int = 3
@export var room_max_size: int = 8

@onready var map_scene: MapScene = $MapScene
@onready var generator: MapGenerator = MapGenerator.new(map_seed)

var _map: Map
var _character_positions: Dictionary[Character, Vector2i] = {}

func _ready():
	Signals.character_spawned.connect(_on_character_spawn)
	Signals.character_died.connect(_on_character_died)
	create_map()

func create_map():
	_map = generator.generate(map_width, map_height, room_min_size, room_max_size)
	map_scene.create(_map, map_seed)

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
