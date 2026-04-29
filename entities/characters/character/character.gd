extends Node2D
class_name Character

signal character_spawned(character: Character)
signal character_died(character: Character)

@export var title: String

@export_group("Stats")
@export var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_spawned.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_turn() -> void:
	print(title + " taking turn")

func die() -> void:
	character_died.emit(self)
