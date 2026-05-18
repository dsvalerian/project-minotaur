class_name MapManager extends Node2D

@export var seed: int
@export var size: int

@onready var renderer = $MapRenderer
@onready var generator = MapGenerator.new(seed)

var _map: MapData

func _ready():
	create_map()
	
func create_map():
	_map = generator.generate(size)
	renderer.render(_map)
