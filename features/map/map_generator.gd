class_name MapGenerator extends RefCounted

const DIRECTIONS = {
	CellData.Exit.NORTH: Vector2i(0, -1),
	CellData.Exit.EAST: Vector2i(1, 0),
	CellData.Exit.SOUTH: Vector2i(0, 1),
	CellData.Exit.WEST: Vector2i(-1, 0)
}

const OPPOSITES = {
	CellData.Exit.NORTH: CellData.Exit.SOUTH,
	CellData.Exit.SOUTH: CellData.Exit.NORTH,
	CellData.Exit.WEST: CellData.Exit.EAST,
	CellData.Exit.EAST: CellData.Exit.WEST
}

var _rng: RandomNumberGenerator

func _init(map_seed: int):
	_rng = RandomNumberGenerator.new()
	_rng.seed = map_seed

# Return a dictionary of position (Vector2i) -> CellData
func generate(size: int) -> MapData:
	print("Generating map with seed %d..." % [_rng.seed])
	
	var map = MapData.new()
	map.cells = _generate_cells(size)
	map.bounds = _calculate_bounds(map.cells)
	map.features = _generate_features(map.cells)
	
	return map
	
func _generate_cells(size: int) -> Dictionary[Vector2i, CellData]:
	print("Generating cells...")
	var cells: Dictionary[Vector2i, CellData] = {}
	
	# place start cell
	var current = Vector2i(0, 0)
	var current_cell = CellData.new()
	current_cell.grid_position = current
	cells[current] = current_cell
	
	# random walk from start cell
	for i in size:
		var direction = DIRECTIONS.keys()[_rng.randi_range(0, DIRECTIONS.size() - 1)]
		var next = current + DIRECTIONS[direction]
		
		# if cell doesn't already exist in that spot, place it
		if not cells.has(next):
			var next_cell = CellData.new()
			next_cell.grid_position = next
			cells[next] = next_cell
			
		# create the exits between the current and next cell
		cells[current].create_exit(direction)
		cells[next].create_exit(OPPOSITES[direction])
		
		current = next
			
	return cells
	
func _generate_features(cells: Dictionary[Vector2i, CellData]) -> Dictionary[Vector2i, CellFeature.Type]:
	print("Generating features...")
	var features: Dictionary[Vector2i, CellFeature.Type] = {}
	var entrance_pos = _get_random_cell_position(cells)
	features[entrance_pos] = CellFeature.Type.FLOOR_ENTRANCE
	
	var exit_pos = _get_random_cell_position(cells)
	while features.has(exit_pos):
		exit_pos = _get_random_cell_position(cells)
	features[exit_pos] = CellFeature.Type.FLOOR_EXIT
		
	var treasure_chest_pos = _get_random_cell_position(cells)
	for i in 3:
		while features.has(treasure_chest_pos):
			treasure_chest_pos = _get_random_cell_position(cells)
		features[treasure_chest_pos] = CellFeature.Type.TREASURE_CHEST
	
	return features

func _get_random_cell_position(cells: Dictionary[Vector2i, CellData]) -> Vector2i:
	return cells.keys()[_rng.randi_range(0, cells.size() - 1)]

func _calculate_bounds(cells: Dictionary[Vector2i, CellData]) -> Rect2i:
	print("Calculating bounds...")
	var min_x = INF;
	var max_x = -INF;
	var min_y = INF;
	var max_y = -INF;
	for position in cells:
		min_x = min(min_x, position.x)
		max_x = max(max_x, position.x)
		min_y = min(min_y, position.y)
		max_y = max(max_y, position.y)
		
	return Rect2i(min_x, min_y, max_x - min_x, max_y - min_y)
