class_name ClassSelectSlot extends Panel

@onready var class_icon: TextureRect = %ClassIcon
@onready var highlight: Panel = %IsSelectedHighlight
@onready var select_button: TextureButton = %ClassSelectButton

@export var is_being_selected: bool = false:
	set(is_selected):
		is_being_selected = is_selected
		highlight.visible = is_selected
		

@export var character_class: CharacterClass:
	set(new_class):
		if new_class:
			character_class = new_class
			if is_inside_tree():
				class_icon.texture = character_class.icon
		else:
			character_class = null
			if is_inside_tree():
				class_icon.texture = Texture2D.new()

func _ready():
	if character_class:
		class_icon.texture = character_class.icon
	else:
		class_icon.texture = Texture2D.new()

func connect_select_press(function) -> void:
	select_button.pressed.connect(function)
