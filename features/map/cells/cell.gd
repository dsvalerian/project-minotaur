extends Node2D
class_name Cell

@export var left_wall: bool = false
@export var upper_wall: bool = false
@export var right_wall: bool = false
@export var lower_wall: bool = false

@export var tile_atlas_coords: Vector3i = Vector3i(2, 0, 0)

func has_left_wall() -> bool:
	return left_wall

func has_upper_wall() -> bool:
	return upper_wall

func has_right_wall() -> bool:
	return right_wall

func has_lower_wall() -> bool:
	return lower_wall

func get_atlas_coordinates():
	return tile_atlas_coords

func get_atlas_coords_2d():
	return Vector2i(tile_atlas_coords.x, tile_atlas_coords.y)

func get_alt_tile_id():
	return tile_atlas_coords.z
