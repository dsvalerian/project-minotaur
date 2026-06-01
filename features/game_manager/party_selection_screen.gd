class_name PartySelectionScreen extends Control

@onready var class_options: GridContainer = %ClassOptions
@onready var stats_display: Label = %StatsDisplay
@onready var continue_button: Button = %ContinueButton

@onready var P1: ClassSelectSlot = %ClassSelectSlot1
@onready var P2: ClassSelectSlot = %ClassSelectSlot2
@onready var P3: ClassSelectSlot = %ClassSelectSlot3
@onready var P4: ClassSelectSlot = %ClassSelectSlot4

@onready var to_select: Array[ClassSelectSlot] = [P1, P2, P3, P4] 
var to_select_idx: int = 0
var selected_classes: Array[CharacterClass] = []

const NUM_PLAYERS = 4
const class_option_slot_scene = preload("res://features/game_manager/class_option_slot.tscn")
const selected_class_slot_scene = preload("res://features/game_manager/class_select_slot.tscn")

@onready var class_resources: Array[CharacterClass] = [
	preload("res://features/characters/fighter/fighter.tres"),
	preload("res://features/characters/priest/priest.tres"),
	preload("res://features/characters/rogue/rogue.tres"),
	preload("res://features/characters/wizard/wizard.tres"),
]

func _ready() -> void:
	for character_class in class_resources:
		var slot = class_option_slot_scene.instantiate()
		slot.character_class = character_class
		class_options.add_child(slot)
		slot.connect_mouse_entered_function(_handle_mouse_over_option.bind(character_class))
		slot.connect_pressed_function(_handle_click_on_option.bind(character_class))
	P1.connect_select_press(_handle_click_on_select_slot.bind(0))
	P2.connect_select_press(_handle_click_on_select_slot.bind(1))
	P3.connect_select_press(_handle_click_on_select_slot.bind(2))
	P4.connect_select_press(_handle_click_on_select_slot.bind(3))
	P1.is_being_selected = true
	selected_classes.resize(NUM_PLAYERS)

func _handle_mouse_over_option(character_class: CharacterClass):
	if to_select_idx < NUM_PLAYERS:
		var being_selected: ClassSelectSlot = to_select[to_select_idx]
		being_selected.character_class = character_class

func _handle_click_on_option(character_class: CharacterClass):
	var being_selected: ClassSelectSlot = to_select[to_select_idx]
	being_selected.character_class = character_class
	being_selected.is_being_selected = false
	selected_classes[to_select_idx] = character_class
	to_select_idx = get_next_slot()
	if _is_all_characters_selected():
		continue_button.disabled = false
	if to_select_idx < to_select.size():
		to_select[to_select_idx].is_being_selected = true

func _handle_click_on_select_slot(idx: int):
	if to_select_idx < NUM_PLAYERS:
		var being_selected = to_select[to_select_idx]
		being_selected.is_being_selected = false
		being_selected.character_class = selected_classes[to_select_idx]
	if idx < NUM_PLAYERS:
		to_select_idx = idx
		to_select[to_select_idx].is_being_selected = true

func _handle_continue_button_pressed() -> void:
	Signals.party_selected.emit(selected_classes)

func get_next_slot() -> int:
	for i in range(selected_classes.size()):
		if !selected_classes[i]:
			return i
	return NUM_PLAYERS

func _is_all_characters_selected() -> bool:
	return selected_classes[0] != null && selected_classes[1] != null && selected_classes[2] != null && selected_classes[3] != null
