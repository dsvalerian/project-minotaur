class_name MapManager extends Node2D

@export var map_seed: int
@export var map_size: int

@onready var map: GameMap = $GameMap
@onready var generator: MapGenerator = MapGenerator.new(map_seed)

var _map_data: MapData
var _character_coords: Dictionary[Character, Vector2i]

func _ready():
	Signals.character_spawned.connect(_on_character_spawn)
	create_map()
	
func create_map():
	_map_data = generator.generate(map_size)
	map.create(_map_data)

func _on_character_spawn(character: Character) -> void:
	var coords = _map_data.features.find_key(CellFeature.Type.FLOOR_ENTRANCE)
	_character_coords[character] = coords
	# character.position = $Map.cell_layer.map_to_local(coords) * $Map.cell_layer.scale
	_reposition_characters_in_cell(coords)

func _reposition_characters_in_cell(coords: Vector2i) -> void:
	var characters_at_coords = _character_coords.keys().filter(func(k): return _character_coords[k] == coords)
	var size = characters_at_coords.size()
	var local_coords = $Map.cell_layer.map_to_local(coords)
	var _scale = $Map.cell_layer.scale
	var cell_size = Vector2($Map.cell_layer.tile_set.tile_size) * _scale
	if  size == 0:
		return
	elif size == 1:
		characters_at_coords[0].position = local_coords * _scale
	elif size == 2:
		characters_at_coords[0].position = Vector2i(local_coords * _scale) - Vector2i(floor(0.25 * cell_size.x), 0)
		characters_at_coords[1].position = Vector2i(local_coords * _scale) + Vector2i(floor(0.25 * cell_size.x), 0)
	else:
		var middle_of_cell = Vector2(local_coords * _scale)
		var top_left_of_cell = middle_of_cell - Vector2(0.5 * cell_size.x, 0.5 * cell_size.y)
		var offsets = make_array_of_offsets(size, cell_size)
		for i in range(0, size):
			var character = characters_at_coords[i]
			character.position = top_left_of_cell + offsets[i]

func make_array_of_offsets(num_items: int, cell_size: Vector2) -> Array[Vector2]:
	var square_side_num_elements = _get_square_side_num_elements(num_items)
	var offsets = []
	for i in range(square_side_num_elements):
		offsets.append(cell_size * (float(i + 1) / float(square_side_num_elements + 1)))
	var ret: Array[Vector2] = []
	ret.resize(square_side_num_elements * square_side_num_elements)
	for i in range(square_side_num_elements):
		for j in range(square_side_num_elements):
			ret[i * square_side_num_elements + j] = Vector2(offsets[j].x, offsets[i].y)
	return ret


func _get_square_side_num_elements(total_num_elements: int):
	for i in range(0, 10):
		if i * i >= total_num_elements:
			return i
	return 10 # This realistically will never be this big so yolo
