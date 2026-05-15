class_name TurnManager extends Control

var characters: Array[Character]

@onready var turn_order_display = $TurnOrderDisplay

func _ready():
	Signals.turn_ended.connect(_on_end_turn_button_pressed)
	render_menu()

func render_menu() -> void:
	for child in turn_order_display.get_children():
		child.queue_free()
	for i in range(characters.size()):
		var child = characters[i].get_portrait()
		turn_order_display.add_child(child)

func _on_end_turn_button_pressed() -> void:
	var just_went: Character = characters.pop_front()
	print(just_went)
	characters.push_back(just_went)
	render_menu()

func get_next_character() -> Character:
	return characters.front()

func setup(_characters: Array[Character]):
	characters = _characters
