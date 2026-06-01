extends Node

@export var num_floors: int
@export var floor_sizes: Array[Vector2i]
@export var num_random_events: Array[int]
@export var map_theme: MapTheme
@export var required_rooms: Array[Room]
@export var random_event_rooms: Array[Room]

func _ready() -> void:
	assert(floor_sizes.size() == num_floors)
	assert(num_random_events.size() == num_floors)
