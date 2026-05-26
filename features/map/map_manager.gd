class_name MapManager extends Node2D

@export var map_seed: int
@export var map_size: int

@onready var map = $Map
@onready var generator = MapGenerator.new(map_seed)

var _map_data: MapData

func _ready():
	Signals.character_spawned.connect(_on_character_spawn)
	create_map()
	
func create_map():
	_map_data = generator.generate(map_size)
	map.create(_map_data)

func _on_character_spawn(character: Character) -> void:
	map._on_character_spawn(character, _map_data)
