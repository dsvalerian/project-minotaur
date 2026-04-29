extends Node
class_name GameManager

@onready var turn_manager = $TurnManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_manager.run_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
