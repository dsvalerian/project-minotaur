class_name Character extends Interactable

@export var character_name: String
@export var character_class: CharacterClass
@export var character_stats: Stats

func _ready() -> void:
	character_stats = character_class.base_stats
	$CharacterSprite.texture = character_class.icon
	Signals.character_spawned.emit(self)

func die() -> void:
	Signals.character_died.emit(self)
