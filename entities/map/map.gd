extends TileMapLayer
class_name Map

const HALLWAY = Vector2i(0, 0)
const CORNER = Vector2i(1, 0)
const ROOM = Vector2i(2, 0)
const T_JUNCTION = Vector2i(3, 0)
const DEAD_END = Vector2i(0, 1)

const LEFT = 0
const UP = 1
const RIGHT = 2
const DOWN = 3

# Initialize Data Structures
var maze = TileMapLayer.new()
var has_left_wall = TileMapLayer.new()
var has_upper_wall = TileMapLayer.new()
var has_right_wall = TileMapLayer.new()
var has_lower_wall = TileMapLayer.new()

var loop_iter_max = 100
var loop_iter_count = 0

func _ready():
	# TODO random string
	generate(5, 5, "sugma")

func generate(x_length, y_length, seed):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)

	
	# TODO check if spawn and exit are valid, maybe enforce distance
	# TODO choose extra unique room
	# choose in/out
	var exit_coords = Vector2i(rng.randf() * x_length, rng.randf() * y_length)
	var spawn_coords = Vector2i(rng.randf() * x_length, rng.randf() * y_length)
	print(exit_coords, spawn_coords)

	var keep_generating = true

	while (keep_generating):
		if (is_done()):
			keep_generating = false
	
	render(x_length, y_length)


func is_done():
	# TODO actually check maze is gen, condition is there is exactly one path between spawn and exit
	return loop_iter_count == loop_iter_max

func apply_rules(x, y):
	# check neighbors have walls
	# check edges/corners
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
							set_cell(vec, 0, T_JUNCTION, 6)
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
							set_cell(vec, 0, T_JUNCTION, 7)
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
