extends TileMapLayer

const HALLWAY = Vector2i(0, 0)
const CORNER = Vector2i(1, 0)
const ROOM = Vector2i(2, 0)
const T_JUNCTION = Vector2i(3, 0)
const DEAD_END = Vector2i(4, 0)

func _ready():
	set_cell(Vector2i(0, 0), 0, HALLWAY)
	set_cell(Vector2i(1, 0), 0, Vector2i(3, 0))
	var cell_to_flip = get_cell_tile_data(Vector2i(0, 0))
	print(cell_to_flip)
	cell_to_flip.transpose = true
	cell_to_flip.flip_h = true
