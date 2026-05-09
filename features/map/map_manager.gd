extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_floor(0, 10, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_floor(floor_number: int, x_length: int, y_length: int):
	var map_floor = $MapFloor
	#var seed = rng.randi()
	var seed = "sugma"
	map_floor.generate(x_length, y_length, seed)
