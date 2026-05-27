extends Node2D

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
	map_manager.add_child(fighter)
	map_manager.add_child(priest)
	map_manager.add_child(rogue)
	map_manager.add_child(wizard)
