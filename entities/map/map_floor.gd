extends TileMapLayer
class_name Map

# Initialize Data Structures
var placed_tiles: TileMapLayer = TileMapLayer.new()
var cells: Array[Array]

func generate(x_length = 20, y_length = 20, floor_seed = "ligma"):
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = hash(floor_seed)
	cells.resize(x_length)
	for i in range(x_length):
		cells[i] = []
		cells[i].resize(y_length)
	var cell_factory = CellFactory.new()
	var cell;
	for x in range(x_length):
		for y in range(y_length):
			if (x == 0):
				if (y == 0):
					cell = cell_factory.get_cell_from_walls(true, true, false, false)
				elif (y == y_length - 1):
					cell = cell_factory.get_cell_from_walls(true, false, false, true)
				else:
					cell = cell_factory.get_cell_from_walls(true, false, false, false)
			elif (x == x_length - 1):
				if (y == 0):
					cell = cell_factory.get_cell_from_walls(false, true, true, false)
				elif (y == y_length - 1):
					cell = cell_factory.get_cell_from_walls(false, false, true, true)
				else:
					cell = cell_factory.get_cell_from_walls(false, false, true, false)
			else:
				if (y == 0):
					cell = cell_factory.get_cell_from_walls(false, true, false, false)
				elif (y == y_length - 1):
					cell = cell_factory.get_cell_from_walls(false, false, false, true)
				else:
					cell = cell_factory.get_cell_from_walls(false, false, false, false)
			set_cell(Vector2i(x, y), 0, cell.get_atlas_coords_2d(), cell.get_alt_tile_id())
					
	# var entrance: Vector2i = choose_entrance_corner(x_length, y_length)
	# var exit: Vector2i = choose_exit_corner(x_length, y_length)


#func choose_entrance_corner(x_length, y_length) -> Vector2i:
#	return Vector2i(0, 0)
#
#func choose_exit_corner(x_length, y_length) -> Vector2i:
#	return Vector2i(x_length - 1, y_length - 1)
