extends TileMapLayer
class_name Map

enum Direction {LEFT, UP, RIGHT, DOWN}

func generate(x_length = 20, y_length = 20, floor_seed = "ligma") -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = hash(floor_seed)
	var visited = TileMapLayer.new()
	var cells = [];
	cells.resize(x_length)
	for x in range(x_length):
		var arr = []
		arr.resize(y_length)
		cells[x] = arr;
	

func walk(coords: Vector2i, visited: Array[Vector2i]):
	pass

func can_move_left(coords: Vector2i, empty_tiles: Array) -> bool:
	var coords_to_move_to = Vector2i(coords.x - 1, coords.y)
	return empty_tiles.has()


func random_coords(rng, x_max, y_max) -> Vector2i:
	return Vector2i(rng.randi_range(0, x_max - 1), rng.randi_range(0, y_max-1))

func get_placeholder_cell() -> Cell:
	return CellFactory.get_cell_from_walls(false, false, false, false);

func generate_walls_and_floors_for_testing(x_length, y_length):
	var cell;
	for x in range(x_length):
		for y in range(y_length):
			if (x == 0):
				if (y == 0):
					cell = CellFactory.get_cell_from_walls(true, true, false, false)
				elif (y == y_length - 1):
					cell = CellFactory.get_cell_from_walls(true, false, false, true)
				else:
					cell = CellFactory.get_cell_from_walls(true, false, false, false)
			elif (x == x_length - 1):
				if (y == 0):
					cell = CellFactory.get_cell_from_walls(false, true, true, false)
				elif (y == y_length - 1):
					cell = CellFactory.get_cell_from_walls(false, false, true, true)
				else:
					cell = CellFactory.get_cell_from_walls(false, false, true, false)
			else:
				if (y == 0):
					cell = CellFactory.get_cell_from_walls(false, true, false, false)
				elif (y == y_length - 1):
					cell = CellFactory.get_cell_from_walls(false, false, false, true)
				else:
					cell = CellFactory.get_cell_from_walls(false, false, false, false)
			set_cell(Vector2i(x, y), 0, cell.get_atlas_coords_2d(), cell.get_alt_tile_id())
					
