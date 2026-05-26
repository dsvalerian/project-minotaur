class_name CharacterPortrait extends Container

var character: Character
var picture: TextureRect
var name_label: Label
var aspect_ratio_container: AspectRatioContainer

const portrait_scene: PackedScene = preload("res://features/game_manager/gameplay/hud/character_portrait.tscn")

static func _create_portrait(_character: Character) -> CharacterPortrait:
	var portrait = portrait_scene.instantiate()
	portrait.character = _character
	return portrait

func _ready() -> void:
	picture = $PortraitAspectRatioContainer/PortraitBorder/CharacterPicture
	name_label = $PortraitAspectRatioContainer/PortraitBorder/NameBox/CharacterName
	aspect_ratio_container = $PortraitAspectRatioContainer

	var texture = character.get_sprite().texture
	picture.texture = texture
	picture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	picture.stretch_mode = TextureRect.STRETCH_SCALE
	picture.custom_minimum_size = Vector2(32, 32)
	name_label.text = character.title
	# aspect_ratio_container.ratio = float(9) / float(16)
