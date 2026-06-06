class_name MapScene extends Node2D

const DIR_N  = Vector2i(0, -1)
const DIR_E  = Vector2i(1,  0)
const DIR_S  = Vector2i(0,  1)
const DIR_W  = Vector2i(-1,  0)
const DIR_NE = Vector2i(1, -1)
const DIR_NW = Vector2i(-1, -1)
const DIR_SE = Vector2i(1,  1)
const DIR_SW = Vector2i(-1,  1)

@onready var background: ColorRect = $BackgroundLayer/Background
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer:  TileMapLayer = $WallLayer
@onready var entity_layer: Node2D = $EntityLayer
@onready var character_layer: Node2D = $CharacterLayer
@onready var movement_layer: Node2D = $MovementLayer

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
	return _rand_vector(1, 1, 4, 3)

func _get_atlas_wall_cell(pos: Vector2i, map: Map) -> Vector2i:
	# [N, NE, E, SE, S, SW, W, NW]
	var f = [
		map.is_floor(pos + DIR_N),
		map.is_floor(pos + DIR_NE),
		map.is_floor(pos + DIR_E),
		map.is_floor(pos + DIR_SE),
		map.is_floor(pos + DIR_S),
		map.is_floor(pos + DIR_SW),
		map.is_floor(pos + DIR_W),
		map.is_floor(pos + DIR_NW)
	]
	match f:
		[false, _, true, _, false, _, false, true]:
			return _rand_vector(3, 7, 5, 7)
		[false, true, false, _, false, _, true, _]:
			return _rand_vector(0, 7, 2, 7)
		# S floor → N-face (highest priority; S always dominates)
		[_, _, _, _, true, _, _, _]:
			return _rand_vector(1, 0, 4, 0)
		# N+E+W, no S → E+W+S-top (row 6, cols 3-5); must precede N+E and N+W
		[true, _, true, _, false, _, true, _]:
			return _rand_vector(3, 6, 5, 6)
		# N+E, no S → WR+ST inner corner (row 5, cols 3-5)
		[true, _, true, _, false, _, _, _]:
			return _rand_vector(3, 5, 5, 5)
		# N+W, no S → EL+ST inner corner (row 5, cols 0-2)
		[true, _, _, _, false, _, true, _]:
			return _rand_vector(0, 5, 2, 5)
		# N only + SE diagonal → WR+ST (south wall bends to right)
		[true, _, false, true, false, _, false, _]:
			return _rand_vector(3, 5, 5, 5)
		# N only + SW diagonal → EL+ST (south wall bends to left)
		[true, _, false, _, false, true, false, _]:
			return _rand_vector(0, 5, 2, 5)
		# N only → plain S-edge
		[true, _, false, _, false, _, false, _]:
			return _rand_vector(1, 4, 4, 4)
		# E+W, no N/S → E+W double wall (row 6, cols 0-2)
		[false, _, true, _, false, _, true, _]:
			return _rand_vector(0, 6, 2, 6)
		# E + SW diagonal (N-face sits to left) → E+W double wall
		[false, _, true, _, false, true, false, _]:
			return _rand_vector(0, 6, 2, 6)
		# W + SE diagonal (N-face sits to right) → E+W double wall
		[false, _, false, true, false, _, true, _]:
			return _rand_vector(0, 6, 2, 6)
		# E only → W-edge
		[false, _, true, _, false, _, false, _]:
			return _rand_vector(0, 1, 0, 3)
		# W only → E-edge
		[false, _, false, _, false, _, true, _]:
			return _rand_vector(5, 1, 5, 3)
		# Outer corners — no cardinal floor, single diagonal
		[false, _, false, true, false, _, false, _]:   # SE diag → NW outer corner
			return Vector2i(0, 0)
		[false, _, false, _, false, true, false, _]:   # SW diag → NE outer corner
			return Vector2i(5, 0)
		[false, true, false, _, false, _, false, _]:   # NE diag → SW outer corner
			return Vector2i(0, 4)
		[false, _, false, _, false, _, false, true]:   # NW diag → SE outer corner
			return Vector2i(5, 4)
		_:
			return Vector2i(6, 0)

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
