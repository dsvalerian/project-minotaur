extends Character
class_name Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("players")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
