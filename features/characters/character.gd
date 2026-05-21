extends Node2D 
class_name Character

@export var title: String

@export_group("Stats")
@export var health: int

func get_portrait() -> Container:
	var texture = $CharacterSprite.texture
	var rect = TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.custom_minimum_size = Vector2(32, 32)
	var ratio = AspectRatioContainer.new()
	ratio.add_child(rect)
	ratio.ratio = 9 / 16;
	return ratio 

func _ready() -> void:
	Signals.character_spawned.emit(self)

func die() -> void:
	Signals.character_died.emit(self)
