extends TileMapLayer

var HALLWAY = Vector2i(0, 0);

func _ready():
	set_cell(Vector2i(0, 0), 0, HALLWAY)
	set_cell(Vector2i(1, 0), 0, Vector2i(3, 0))
	var cell_to_flip = get_cell_tile_data(Vector2i(0, 0))
	print(cell_to_flip)
	cell_to_flip.transpose = true;
	cell_to_flip.flip_h = true;
