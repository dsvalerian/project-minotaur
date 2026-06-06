extends Node

var classes: Dictionary[String, CharacterClass] = {
	"Fighter": preload("res://features/characters/fighter/fighter.tres"),
	"Wizard": preload("res://features/characters/wizard/wizard.tres"),
	"Rogue": preload("res://features/characters/rogue/rogue.tres"),
	"Priest": preload("res://features/characters/priest/priest.tres")
}

var default_character_class = preload("res://features/characters/default/default.tres")
