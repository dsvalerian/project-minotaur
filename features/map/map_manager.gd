class_name MapManager extends Node2D

@export var map_seed: int
@export var map_size: int

@onready var map: GameMap = $GameMap
@onready var generator: MapGenerator = MapGenerator.new(map_seed)

var _map_data: MapData

func _ready():
	create_map()
	
func create_map():
	_map_data = generator.generate(map_size)
	map.create(_map_data)
