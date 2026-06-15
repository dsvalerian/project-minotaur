extends HBoxContainer

func _ready():
	Signals.turn_order_change.connect(_on_turn_order_change)

func _on_turn_order_change(characters: Array[Character]):
	for child in get_children():
		child.queue_free()
	for i in range(characters.size()):
		var character_frame: TextureRect = TextureRect.new()
		character_frame.texture = characters[i].sprite.texture
		character_frame.set_stretch_mode(TextureRect.STRETCH_TILE) 
		add_child(character_frame)
