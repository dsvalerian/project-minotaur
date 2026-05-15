extends Node2D 
class_name Character

signal character_spawned(character: Character)
signal character_died(character: Character)

@export var title: String

@export_group("Stats")
@export var health: int

func get_portrait() -> TextureRect:
	var texture = $CharacterSprite.texture
	var rect = TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.custom_minimum_size = Vector2(16, 16)
	return rect
	

func _ready() -> void:
	character_spawned.emit(self)

func take_turn() -> void:
	print(title + " taking turn")

func die() -> void:
	character_died.emit(self)
