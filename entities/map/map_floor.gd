extends TileMapLayer
class_name Map

const HALLWAY = Vector2i(0, 0)
const CORNER = Vector2i(1, 0)
const ROOM = Vector2i(2, 0)
const T_JUNCTION = Vector2i(3, 0)
const DEAD_END = Vector2i(0, 1)

const HALLWAY_0 = Vector3i(0, 0, 0)
const HALLWAY_90 = Vector3i(0, 0, 1)
const CORNER_0 = Vector3i(1, 0, 0)
const CORNER_90 = Vector3i(1, 0, 1)
const CORNER_180 = Vector3i(1, 0, 2)
const CORNER_270 = Vector3i(1, 0, 3)
const ROOM_0 = Vector3i(2, 0, 0)
const T_JUNCTION_0 = Vector3i(3, 0, 0)
const T_JUNCTION_90 = Vector3i(3, 0, 1)
const T_JUNCTION_180 = Vector3i(3, 0, 2)
const T_JUNCTION_270 = Vector3i(3, 0, 3)
const DEAD_END_0 = Vector3i(0, 1, 0)
const DEAD_END_90 = Vector3i(0, 1, 1)
const DEAD_END_180 = Vector3i(0, 1, 2)
const DEAD_END_270 = Vector3i(0, 1, 3)

const LEFT = 0
const UP = 1
const RIGHT = 2
const DOWN = 3

# Initialize Data Structures
var placed_tiles = TileMapLayer.new()
var has_left_wall = TileMapLayer.new()
var has_upper_wall = TileMapLayer.new()
var has_right_wall = TileMapLayer.new()
var has_lower_wall = TileMapLayer.new()

@export var loop_iter_max: int  = 1500
var loop_iter_count = 0

func _ready():
	pass

func generate(x_length = 20, y_length = 20, floor_seed = "ligma"):
	clear_data()
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(floor_seed)
	
	# TODO check if spawn and exit are valid, maybe enforce distance
	# TODO choose extra unique room
	var exit_coords = Vector2i(int(rng.randf() * x_length), int(rng.randf() * y_length))
	var spawn_coords = Vector2i(int(rng.randf() * x_length), int(rng.randf() * y_length))
	print(exit_coords, spawn_coords)
	
	var keep_generating = true
	
	initialize_map_boundaries(x_length, y_length)
	var theoretical_tiles_arr = generate_starting_tile_options(x_length, y_length)
	
	while (keep_generating):
		# pick tile with the least options (or randomly pick amongst the ones with the least options)
		var chosen_tile_coords = choose_tile_with_least_options(theoretical_tiles_arr, rng)
		var x = chosen_tile_coords[0]
		var y = chosen_tile_coords[1]

		# randomly add a wall TODO change to just picking a tile
		var wall_side = randomly_select_side_for_wall(chosen_tile_coords, rng)
		get_wall_layer(wall_side).set_cell(Vector2i(x, y), 0, ROOM)
		
		# validate that wall doesn't break the rules
		if (!is_wall_placement_valid(spawn_coords, exit_coords)):
			continue
		else:
			placed_tiles.set_cell(Vector2i(x, y), 0, ROOM)
		
		# re-assess valid tile options for every tile
		
		# prep loop and check for done
		loop_iter_count += 1
		keep_generating = !is_done()
	
	render(x_length, y_length)

func clear_data():
	placed_tiles.clear()
	has_left_wall.clear()
	has_upper_wall.clear()
	has_right_wall.clear() 
	has_lower_wall.clear()

func is_wall_placement_valid(spawn_coords, exit_coords):
	return maze_has_path(spawn_coords, exit_coords) && maze_has_no_islands(spawn_coords, exit_coords)

func maze_has_no_islands(spawn_coords, exit_coords):
	return true

func maze_has_path(spawn_coords, exit_coords):
	return can_traverse_maze(spawn_coords, exit_coords)

func can_traverse_maze(current_coords, exit_coords):
	return true

func get_wall_layer(side):
	if (side == LEFT): return has_left_wall;
	if (side == UP): return has_upper_wall;
	if (side == RIGHT): return has_right_wall;
	if (side == DOWN): return has_lower_wall;

func randomly_select_side_for_wall(coords, rng):
	var x = coords[0]
	var y = coords[1]
	var walls = []
	if (!has_wall(x, y, LEFT)):
		walls.push_front(LEFT)
	if (!has_wall(x, y, UP)):
		walls.push_front(UP)
	if (!has_wall(x, y, RIGHT)):
		walls.push_front(RIGHT)
	if (!has_wall(x, y, DOWN)):
		walls.push_front(DOWN)
	
	return walls[walls.size() * rng.randf()]

func choose_tile_with_least_options(tiles_arr: Array, rng: RandomNumberGenerator):
	# TODO check if tile has already been placed
	var x_length = tiles_arr.size()
	var y_length = tiles_arr[0].size()
	var min_possible_tiles = 100 # or any number larger than the number of tiles
	var all_tiles_with_min_possible = []
	for x in range(x_length):
		for y in range(y_length):
			if (tile_has_been_placed(x, y) || tile_has_three_walls(x, y)):
				continue
			var curr_size = tiles_arr[x][y].size()
			if (curr_size < min_possible_tiles):
				min_possible_tiles = curr_size
				all_tiles_with_min_possible.clear()
				all_tiles_with_min_possible.push_front([x, y])
			elif (curr_size == min_possible_tiles):
				all_tiles_with_min_possible.push_front([x, y])
	if (all_tiles_with_min_possible.size() == 1):
		return all_tiles_with_min_possible[0]
	else:
		return all_tiles_with_min_possible[int(all_tiles_with_min_possible.size() * rng.randf())]

func tile_has_three_walls(x, y):
	var walls = 0
	if (has_wall(x, y, LEFT)): walls += 1
	if (has_wall(x, y, UP)): walls += 1
	if (has_wall(x, y, RIGHT)): walls += 1
	if (has_wall(x, y, DOWN)): walls += 1
	return walls >= 3

func tile_has_been_placed(x, y):
	return placed_tiles.get_cell_source_id(Vector2i(x, y)) != -1

func initialize_map_boundaries(x_length, y_length):
	for x in range(x_length):
		has_upper_wall.set_cell(Vector2i(x, 0), 0, ROOM)
		has_lower_wall.set_cell(Vector2i(x, y_length - 1), 0, ROOM)
	for y in range(y_length):
		has_left_wall.set_cell(Vector2i(0, y), 0, ROOM)
		has_right_wall.set_cell(Vector2i(x_length - 1, y), 0, ROOM)

func is_done():
	# TODO actually check maze is gen, condition is there is exactly one path between spawn and exit
	return loop_iter_count == loop_iter_max

func apply_rules():
	# check neighbors have walls
	# check edges/corners
	# if it has three walls it has to be a DEAD_END
	# no island tiles (all tiles reachable from entrance and exit)
	# no cycles
	# check if wall is generated that a path between exit and entrance still exists
	pass

func has_wall(x, y, side):
	if (side == LEFT):
		return has_left_wall.get_cell_source_id(Vector2i(x, y)) != -1
	elif (side == UP):
		return has_upper_wall.get_cell_source_id(Vector2i(x, y)) != -1
	elif (side == RIGHT):
		return has_right_wall.get_cell_source_id(Vector2i(x, y)) != -1
	else:
		return has_lower_wall.get_cell_source_id(Vector2i(x, y)) != -1

func get_all_tiles():
	var ret = {}
	
	ret[key(HALLWAY_0)] = HALLWAY_0
	ret[key(HALLWAY_90)] = HALLWAY_90
	
	ret[key(CORNER_0)] = CORNER_0
	ret[key(CORNER_90)] = CORNER_90
	ret[key(CORNER_180)] = CORNER_180
	ret[key(CORNER_270)] = CORNER_270
	
	ret[key(ROOM_0)] = ROOM_0
	
	ret[key(T_JUNCTION_0)] = T_JUNCTION_0
	ret[key(T_JUNCTION_90)] = T_JUNCTION_90
	ret[key(T_JUNCTION_180)] = T_JUNCTION_180
	ret[key(T_JUNCTION_270)] = T_JUNCTION_270
	
	ret[key(DEAD_END_0)] = DEAD_END_0
	ret[key(DEAD_END_90)] = DEAD_END_90
	ret[key(DEAD_END_180)] = DEAD_END_180
	ret[key(DEAD_END_270)] = DEAD_END_270
	
	return ret

func generate_starting_tile_options(x_length, y_length):
	var ret = []
	ret.resize(x_length)
	for x in range(x_length):
		var insert = []
		insert.resize(y_length)
		ret[x] = insert
		for y in range(y_length):
			var tiles = get_all_tiles()
			if (has_wall(x, y, LEFT)): # TODO or if left neighbor has right wall
				tiles.erase(key(HALLWAY_0))
				tiles.erase(key(CORNER_0))
				tiles.erase(key(CORNER_90))
				tiles.erase(key(ROOM_0))
				tiles.erase(key(T_JUNCTION_0))
				tiles.erase(key(T_JUNCTION_90))
				tiles.erase(key(T_JUNCTION_270))
				tiles.erase(key(DEAD_END_0))
			if (has_wall(x, y, UP)):
				tiles.erase(key(HALLWAY_90))
				tiles.erase(key(CORNER_90))
				tiles.erase(key(CORNER_180))
				tiles.erase(key(ROOM_0))
				tiles.erase(key(T_JUNCTION_0))
				tiles.erase(key(T_JUNCTION_90))
				tiles.erase(key(T_JUNCTION_180))
				tiles.erase(key(DEAD_END_90))
			if (has_wall(x, y, RIGHT)):
				tiles.erase(key(HALLWAY_0))
				tiles.erase(key(CORNER_180))
				tiles.erase(key(CORNER_270))
				tiles.erase(key(ROOM_0))
				tiles.erase(key(T_JUNCTION_90))
				tiles.erase(key(T_JUNCTION_180))
				tiles.erase(key(T_JUNCTION_270))
				tiles.erase(key(DEAD_END_180))
			if (has_wall(x, y, DOWN)):
				tiles.erase(key(HALLWAY_90))
				tiles.erase(key(CORNER_0))
				tiles.erase(key(CORNER_270))
				tiles.erase(key(ROOM_0))
				tiles.erase(key(T_JUNCTION_0))
				tiles.erase(key(T_JUNCTION_180))
				tiles.erase(key(T_JUNCTION_270))
				tiles.erase(key(DEAD_END_270))
			ret[x][y] = tiles
	return ret

func render(x_length, y_length):
	for x in range(x_length):
		for y in range(y_length):
			var left_wall_exists = has_left_wall.get_cell_source_id(Vector2i(x, y)) != -1
			var upper_wall_exists = has_upper_wall.get_cell_source_id(Vector2i(x, y)) != -1
			var right_wall_exists = has_right_wall.get_cell_source_id(Vector2i(x, y)) != -1
			var lower_wall_exists = has_lower_wall.get_cell_source_id(Vector2i(x, y)) != -1
			var vec = Vector2i(x, y)

			if (left_wall_exists):
				if (upper_wall_exists):
					if (right_wall_exists):
						if (lower_wall_exists):
							# TODO should never hit here, throw error
							set_cell(vec, 0, ROOM)
						else:
							set_cell(vec, 0, DEAD_END, 3)
					else:
						if (lower_wall_exists):
							set_cell(vec, 0, DEAD_END, 2)
						else: 
							set_cell(vec, 0, CORNER, 3)
				else:
					if (right_wall_exists):
						if (lower_wall_exists):
							set_cell(vec, 0, DEAD_END, 1)
						else:
							set_cell(vec, 0, HALLWAY, 1)
					else:
						if (lower_wall_exists):
							set_cell(vec, 0, CORNER, 2)
						else: 
							set_cell(vec, 0, T_JUNCTION, 2)
			else:
				if (upper_wall_exists):
					if (right_wall_exists):
						if (lower_wall_exists):
							set_cell(vec, 0, DEAD_END)
						else:
							set_cell(vec, 0, CORNER)
					else:
						if (lower_wall_exists):
							set_cell(vec, 0, HALLWAY)
						else: 
							set_cell(vec, 0, T_JUNCTION, 3)
				else:
					if (right_wall_exists):
						if (lower_wall_exists):
							set_cell(vec, 0, CORNER, 1)
						else:
							set_cell(vec, 0, T_JUNCTION)
					else:
						if (lower_wall_exists):
							set_cell(vec, 0, T_JUNCTION, 1)
						else: 
							set_cell(vec, 0, ROOM)

func key(vec: Vector3):
		return "{0},{1},{2}".format([vec.x, vec.y, vec.z])
