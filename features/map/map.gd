class_name Map extends RefCounted

var cells: Dictionary[Vector2i, Cell] = {}
var bounds: Rect2i

func get_cell(pos: Vector2i) -> Cell:
	return cells.get(pos, null)

func is_floor(pos: Vector2i) -> bool:
	var cell: Cell = cells.get(pos, null)
	return cell != null and cell.terrain == Cell.Terrain.FLOOR

func is_wall(pos: Vector2i) -> bool:
	var cell: Cell = cells.get(pos, null)
	return cell != null and cell.terrain == Cell.Terrain.WALL

func get_floor_positions() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for pos in cells:
		if cells[pos].terrain == Cell.Terrain.FLOOR:
			result.append(pos)
	return result

func get_wall_positions() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for pos in cells:
		if cells[pos].terrain == Cell.Terrain.WALL:
			result.append(pos)
	return result

func find_interactable(type: GDScript) -> Vector2i:
	for pos in cells:
		if cells[pos].interactable and cells[pos].interactable.get_script() == type:
			return pos
	return Vector2i(-1, -1)
