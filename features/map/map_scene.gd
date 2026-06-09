class_name MapScene extends Node2D

const DIR_N = Vector2i(0, -1)
const DIR_S = Vector2i(0,  1)
const DIR_E = Vector2i(1,  0)
const DIR_W = Vector2i(-1,  0)

@onready var background: ColorRect = $BackgroundLayer/Background
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer:  TileMapLayer = $WallLayer
@onready var entity_layer: Node2D = $EntityLayer
@onready var character_layer: Node2D = $CharacterLayer

var rng

func create(map: Map, rng_seed: int, theme: MapTheme) -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = rng_seed
	floor_layer.tile_set = theme.tileset
	wall_layer.tile_set = theme.tileset
	background.color = theme.background_color
	canvas_modulate.color = theme.ambient_color
	_render_floor(map)
	_render_walls(map)
	_add_interactables_to_tree(map)

func _render_floor(map: Map) -> void:
	floor_layer.clear()
	for pos in map.get_floor_positions():
		floor_layer.set_cell(pos, 0, _get_atlas_floor_cell())

func _render_walls(map: Map) -> void:
	wall_layer.clear()
	for pos in map.get_wall_positions():
		wall_layer.set_cell(pos, 0, _get_atlas_wall_cell(pos, map))

func _get_atlas_floor_cell() -> Vector2i:
	return _rand_vector(0, 0, 3, 2)

func _get_atlas_wall_cell(pos: Vector2i, map: Map) -> Vector2i:
	var n := map.is_wall(pos + DIR_N)
	var s := map.is_wall(pos + DIR_S)
	var e := map.is_wall(pos + DIR_E)
	var w := map.is_wall(pos + DIR_W)
	match [n, s, e, w]:
		[false, false, false, false]: return Vector2i(0, 3)
		[false, false, true,  false]: return Vector2i(1, 3)
		[false, false, true,  true ]: return Vector2i(2, 3)
		[false, false, false, true ]: return Vector2i(3, 3)
		[false, true,  false, false]: return Vector2i(0, 4)
		[false, true,  true,  false]: return Vector2i(1, 4)
		[false, true,  true,  true ]: return Vector2i(2, 4)
		[false, true,  false, true ]: return Vector2i(3, 4)
		[true,  true,  false, false]: return Vector2i(0, 5)
		[true,  true,  true,  false]: return Vector2i(1, 5)
		[true,  true,  true,  true ]: return Vector2i(2, 5)
		[true,  true,  false, true ]: return Vector2i(3, 5)
		[true,  false, false, false]: return Vector2i(0, 6)
		[true,  false, true,  false]: return Vector2i(1, 6)
		[true,  false, true,  true ]: return Vector2i(2, 6)
		[true,  false, false, true ]: return Vector2i(3, 6)
		_: return Vector2i(0, 3)

func _rand_vector(top_left_x: int, top_left_y: int, bot_right_x: int, bot_right_y: int):
	var x = rng.randi_range(top_left_x, bot_right_x)
	var y = rng.randi_range(top_left_y, bot_right_y)
	return Vector2i(x, y)

func _add_interactables_to_tree(map: Map) -> void:
	for pos in map.cells:
		var cell := map.cells[pos]
		if cell.interactable == null:
			continue
		cell.interactable.position = floor_layer.map_to_local(pos) * floor_layer.scale
		entity_layer.add_child(cell.interactable)
