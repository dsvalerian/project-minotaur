extends Node2D

var characters: Array[Character]
var turn_manager: TurnManager

func _ready() -> void:
	$EndTurnButton.pressed.connect(_on_turn_end)
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
	var turn_manager_scene = preload("res://features/game_manager/gameplay/hud/turn_manager.tscn")
	turn_manager = turn_manager_scene.instantiate()
	turn_manager.setup(characters)
	$TurnOrder.add_child(turn_manager)

func _on_turn_end():
	Signals.turn_ended.emit()

func setup():
	pass
