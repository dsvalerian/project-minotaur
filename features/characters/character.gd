class_name Character extends Interactable

@export var title: String = "John Character"

@export_group("Stats")
@export var max_health: int = 10
@export var initiative: int = 5
@export var speed: int = 2

func get_portrait() -> Container:
	var texture = $CharacterSprite.texture
	var rect = TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.custom_minimum_size = Vector2(32, 32)
	var ratio = AspectRatioContainer.new()
	ratio.add_child(rect)
	ratio.ratio = float(9) / float(16);
	return ratio 

func get_sprite() -> Sprite2D:
	return $CharacterSprite

func _ready() -> void:
	Signals.character_spawned.emit(self)

func die() -> void:
	Signals.character_died.emit(self)
