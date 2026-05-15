class_name CharacterFactory extends RefCounted

enum CharacterClass {FIGHTER, PRIEST, ROGUE, WIZARD}

const fighter_scene = preload("res://features/characters/fighter/fighter.tscn")
const priest_scene = preload("res://features/characters/priest/priest.tscn")
const rogue_scene = preload("res://features/characters/rogue/rogue.tscn")
const wizard_scene = preload("res://features/characters/wizard/wizard.tscn")

static func getCharacterScene(character_class: CharacterClass):
	match character_class:
		CharacterClass.FIGHTER:
			return fighter_scene
		CharacterClass.PRIEST:
			return priest_scene
		CharacterClass.ROGUE:
			return rogue_scene
		CharacterClass.WIZARD:
			return wizard_scene
