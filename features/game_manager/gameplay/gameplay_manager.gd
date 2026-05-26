extends Node2D

var characters: Array[Character]
@onready var turn_manager: TurnManager = $HUD/TopBar/TurnManager
@onready var map_manager: MapManager = $MapManager

func _ready() -> void:
	var fighter_scene = CharacterFactory.getCharacterScene(CharacterFactory.CharacterClass.FIGHTER)
	var priest_scene = CharacterFactory.getCharacterScene(CharacterFactory.CharacterClass.PRIEST)
	var rogue_scene = CharacterFactory.getCharacterScene(CharacterFactory.CharacterClass.ROGUE)
	var wizard_scene = CharacterFactory.getCharacterScene(CharacterFactory.CharacterClass.WIZARD)
	var fighter = fighter_scene.instantiate()
	var priest = priest_scene.instantiate()
	var rogue = rogue_scene.instantiate()
	var wizard = wizard_scene.instantiate()
	characters.push_back(fighter)
	characters.push_back(priest)
	characters.push_back(rogue)
	characters.push_back(wizard)
	map_manager.add_child(fighter)
	map_manager.add_child(priest)
	map_manager.add_child(rogue)
	map_manager.add_child(wizard)

func _on_end_turn_button_pressed() -> void:
	var character = turn_manager.get_next_character()
	print("End turn button pressed by character " + character.to_string())
	Signals.turn_ended.emit(character)
