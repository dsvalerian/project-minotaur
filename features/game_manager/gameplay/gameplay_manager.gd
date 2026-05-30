extends Node2D

@onready var map_manager: MapManager = $MapManager

func _ready() -> void:
	var classes = [
		CharacterFactory.CharacterClass.FIGHTER,
		CharacterFactory.CharacterClass.PRIEST,
		CharacterFactory.CharacterClass.ROGUE,
		CharacterFactory.CharacterClass.WIZARD,
	]
	for cls in classes:
		map_manager.add_child(CharacterFactory.getCharacterScene(cls).instantiate())
	
