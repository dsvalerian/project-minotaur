class_name CellData extends Resource

enum Exit {
	NORTH = 0b0001,
	EAST = 0b0010,
	SOUTH = 0b0100,
	WEST = 0b1000
}

var _exits: int = 0
var grid_position: Vector2i

func has_exit(exit: Exit) -> bool:
	return _exits & exit != 0
	
func create_exit(exit: Exit) -> void:
	_exits |= exit

func remove_exit(exit: Exit) -> void:
	_exits &= ~exit

func get_exits() -> int:
	return _exits
