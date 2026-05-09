extends Node
class_name CellFactory

const Cell0 = preload("res://entities/map/cells/cell.tscn")
const Hallway0 = preload("res://entities/map/cells/hallway_0.tscn")
const Hallway90 = preload("res://entities/map/cells/hallway_90.tscn")
const Corner0 = preload("res://entities/map/cells/corner_0.tscn")
const Corner90 = preload("res://entities/map/cells/corner_90.tscn")
const Corner180 = preload("res://entities/map/cells/corner_180.tscn")
const Corner270 = preload("res://entities/map/cells/corner_270.tscn")
const T0 = preload("res://entities/map/cells/t_0.tscn")
const T90 = preload("res://entities/map/cells/t_90.tscn")
const T180 = preload("res://entities/map/cells/t_180.tscn")
const T270 = preload("res://entities/map/cells/t_270.tscn")
const DeadEnd0 = preload("res://entities/map/cells/dead_end_0.tscn")
const DeadEnd90 = preload("res://entities/map/cells/dead_end_90.tscn")
const DeadEnd180 = preload("res://entities/map/cells/dead_end_180.tscn")
const DeadEnd270 = preload("res://entities/map/cells/dead_end_270.tscn")

func get_cell_from_walls(left_wall: bool, upper_wall: bool, right_wall: bool, lower_wall: bool) -> Cell:
	if (left_wall):
		if (upper_wall):
			if (right_wall):
				if (lower_wall):
					# TODO should never hit here, throw error
					return Cell0.instantiate()
				else:
					return DeadEnd270.instantiate()
			else:
				if (lower_wall):
					return DeadEnd180.instantiate()
				else: 
					return Corner270.instantiate()
		else:
			if (right_wall):
				if (lower_wall):
					return DeadEnd90.instantiate()
				else:
					return Hallway90.instantiate()
			else:
				if (lower_wall):
					return Corner180.instantiate()
				else: 
					return T180.instantiate()
	else:
		if (upper_wall):
			if (right_wall):
				if (lower_wall):
					return DeadEnd0.instantiate()
				else:
					return Corner0.instantiate()
			else:
				if (lower_wall):
					return Hallway0.instantiate()
				else: 
					return T270.instantiate()
		else:
			if (right_wall):
				if (lower_wall):
					return Corner90.instantiate()
				else:
					return T0.instantiate()
			else:
				if (lower_wall):
					return T90.instantiate()
				else: 
					return Cell0.instantiate()