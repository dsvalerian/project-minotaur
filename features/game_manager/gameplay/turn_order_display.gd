extends HBoxContainer

func _ready():
	Signals.turn_order_change.connect(_on_turn_order_change)

func _on_turn_order_change(characters: Array[Character]):
	for child in get_children():
		child.queue_free()
	for i in range(characters.size()):
		add_child(characters[i].get_portrait())
