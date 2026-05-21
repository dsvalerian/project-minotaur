class_name TurnManager extends Control

var characters: Array[Character]

@onready var turn_order_display = $TurnOrderDisplay

func _ready():
	Signals.turn_ended.connect(_on_end_turn)
	Signals.character_spawned.connect(_on_character_spawn)
	Signals.character_died.connect(_on_character_death)
	render_menu()

func render_menu() -> void:
	for child in turn_order_display.get_children():
		child.queue_free()
	for i in range(characters.size()):
		var child = characters[i].get_portrait()
		turn_order_display.add_child(child)

func _on_character_spawn(character: Character) -> void:
	characters.push_back(character)
	render_menu()

func _on_end_turn(character: Character) -> void:
	if (characters[0] == character):
		var just_went: Character = characters.pop_front()
		characters.push_back(just_went)
	render_menu()

func _on_character_death(character: Character) -> void:
	if (characters[0] == character):
		characters.pop_front()
		Signals.turn_ended.emit(character)
	else:
		for i in range(characters.size()):
			if (characters[i] == character):
				characters.remove_at(i)
				break

func get_next_character() -> Character:
	return characters.front()
