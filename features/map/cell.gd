class_name Cell extends RefCounted

enum Terrain { VOID, FLOOR, WALL }

var terrain: Terrain = Terrain.VOID
var interactable: Interactable = null
var character: Character = null

func is_walkable() -> bool:
	return terrain == Terrain.FLOOR and character == null
