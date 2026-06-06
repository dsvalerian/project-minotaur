class_name Party extends RefCounted

var character_scene: PackedScene = preload("res://features/characters/character.tscn")

var p1: Character
var p2: Character
var p3: Character
var p4: Character

func _init(_p1: CharacterClass, _p2: CharacterClass, _p3: CharacterClass, _p4: CharacterClass):
	p1 = character_scene.instantiate()
	p1.character_class = _p1
	p2 = character_scene.instantiate()
	p2.character_class = _p2
	p3 = character_scene.instantiate()
	p3.character_class = _p3
	p4 = character_scene.instantiate()
	p4.character_class = _p4
