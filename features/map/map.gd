class_name Map extends Node2D

const FEATURE_SCENES: Dictionary[CellFeature.Type, Resource] = {
	CellFeature.Type.FLOOR_ENTRANCE: preload("res://features/map/features/floor_entrance/floor_entrance.tscn"),
	CellFeature.Type.FLOOR_EXIT: preload("res://features/map/features/floor_exit/floor_exit.tscn"),
	CellFeature.Type.TREASURE_CHEST: preload("res://features/map/features/treasure_chest/treasure_chest.tscn")
}

const MASK_TO_ATLAS: Dictionary[int, Vector2i] = {
	# 1st row of atlas
	0b1010: Vector2i(0, 0),
	0b0101: Vector2i(1, 0),
	0b1111: Vector2i(2, 0),
	0b0000: Vector2i(3, 0),
	
	# 2nd row of atlas
	0b1000: Vector2i(0, 1),
	0b0001: Vector2i(1, 1),
	0b0010: Vector2i(2, 1),
	0b0100: Vector2i(3, 1),
	
	# 3rd row of atlas
	0b1001: Vector2i(0, 2),
	0b0011: Vector2i(1, 2),
	0b0110: Vector2i(2, 2),
	0b1100: Vector2i(3, 2),
	
	# 4th row of atlas
	0b1101: Vector2i(0, 3),
	0b1011: Vector2i(1, 3),
	0b0111: Vector2i(2, 3),
	0b1110: Vector2i(3, 3)
}

@onready var cell_layer: TileMapLayer = $CellLayer
@onready var feature_layer: Node2D = $FeatureLayer
@onready var character_layer: Node2D = $CharacterLayer
		
func create(map_data: MapData) -> void:
	_render_cells(map_data)
	_instantiate_features(map_data)

func _render_cells(map: MapData) -> void:
	# Render by accessing the coordinates in the tilemap
	cell_layer.clear()
	for cell in map.cells.values():
		cell_layer.set_cell(cell.grid_position, 0, MASK_TO_ATLAS[cell.get_exits()])

func _instantiate_features(map_data: MapData) -> void:
	for pos in map_data.features:
		var node: CellFeature = FEATURE_SCENES[map_data.features[pos]].instantiate()
		node.position = cell_layer.map_to_local(pos) * cell_layer.scale
		feature_layer.add_child(node)
