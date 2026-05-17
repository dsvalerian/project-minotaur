extends Node


func _ready() -> void:
	Signals.character_spawned.connect(_on_character_spawn)
	Signals.turn_ended.connect(_on_turn_end)
	Signals.turn_started.connect(_on_turn_start)

func _on_character_spawn(character: Character):
	print("Character " + character.to_string() + " spawned")

func _on_turn_end(character: Character):
	print("Character " + character.to_string() + " ended turn")

func _on_turn_start(character: Character):
	print("Character " + character.to_string() + " started turn")
