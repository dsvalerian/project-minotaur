class_name TurnManager extends Node2D

var characters: Array[Character]

func _ready():
	Signals.turn_ended.connect(_on_end_turn)
	Signals.character_spawned.connect(_on_character_spawn)
	Signals.character_died.connect(_on_character_death)
	Signals.turn_order_change.emit(characters)

func _on_character_spawn(character: Character) -> void:
	characters.push_back(character)
	Signals.turn_order_change.emit(characters)

func _on_end_turn() -> void:
	var just_went: Character = characters.pop_front()
	characters.push_back(just_went)
	Signals.turn_order_change.emit(characters)

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
