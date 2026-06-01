class_name ClassOptionSlot extends Panel

@export var character_class: CharacterClass

@onready var class_icon: TextureRect = %ClassIcon
@onready var name_display: Label = %ClassName
@onready var select_button = %SelectButton

func _ready() -> void:
	class_icon.texture = character_class.icon
	name_display.text = character_class.character_class_name

func connect_mouse_entered_function(function) -> void:
	select_button.mouse_entered.connect(function)

func connect_pressed_function(function) -> void:
	select_button.pressed.connect(function)
