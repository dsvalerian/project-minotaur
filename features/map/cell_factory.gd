extends RefCounted
class_name CellFactory

const CELL_0 = preload("res://features/map/cells/cell.tscn")
const HALLWAY_0 = preload("res://features/map/cells/hallway_0.tscn")
const HALLWAY_90 = preload("res://features/map/cells/hallway_90.tscn")
const CORNER_0 = preload("res://features/map/cells/corner_0.tscn")
const CORNER_90 = preload("res://features/map/cells/corner_90.tscn")
const CORNER_180 = preload("res://features/map/cells/corner_180.tscn")
const CORNER_270 = preload("res://features/map/cells/corner_270.tscn")
const T_0 = preload("res://features/map/cells/t_0.tscn")
const T_90 = preload("res://features/map/cells/t_90.tscn")
const T_180 = preload("res://features/map/cells/t_180.tscn")
const T_270 = preload("res://features/map/cells/t_270.tscn")
const DEAD_END_0 = preload("res://features/map/cells/dead_end_0.tscn")
const DEAD_END_90 = preload("res://features/map/cells/dead_end_90.tscn")
const DEAD_END_180 = preload("res://features/map/cells/dead_end_180.tscn")
const DEAD_END_270 = preload("res://features/map/cells/dead_end_270.tscn")

static func get_cell_from_walls(left_wall: bool, upper_wall: bool, right_wall: bool, lower_wall: bool) -> Cell:
	if (left_wall):
		if (upper_wall):
			if (right_wall):
				if (lower_wall):
					# TODO should never hit here, throw error
					return CELL_0.instantiate()
				else:
					return DEAD_END_270.instantiate()
			else:
				if (lower_wall):
					return DEAD_END_180.instantiate()
				else: 
					return CORNER_270.instantiate()
		else:
			if (right_wall):
				if (lower_wall):
					return DEAD_END_90.instantiate()
				else:
					return HALLWAY_90.instantiate()
			else:
				if (lower_wall):
					return CORNER_180.instantiate()
				else: 
					return T_180.instantiate()
	else:
		if (upper_wall):
			if (right_wall):
				if (lower_wall):
					return DEAD_END_0.instantiate()
				else:
					return CORNER_0.instantiate()
			else:
				if (lower_wall):
					return HALLWAY_0.instantiate()
				else: 
					return T_270.instantiate()
		else:
			if (right_wall):
				if (lower_wall):
					return CORNER_90.instantiate()
				else:
					return T_0.instantiate()
			else:
				if (lower_wall):
					return T_90.instantiate()
				else: 
					return CELL_0.instantiate()
