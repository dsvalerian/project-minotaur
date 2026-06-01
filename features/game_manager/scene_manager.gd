extends Control

@onready var between_runs_screen: Control = %BetweenRunsScreen
@onready var chapter_select_screen: Control = %ChapterSelectScreen
@onready var party_select_screen: Control = %PartySelectionScreen

@onready var chapter_1_button: Button = %Chapter1Button
@onready var chapter_2_button: Button = %Chapter2Button
@onready var chapter_3_button: Button = %Chapter3Button
@onready var chapter_4_button: Button = %Chapter4Button
@onready var chapter_5_button: Button = %Chapter5Button

var selected_chapter: int

func _ready() -> void:
	chapter_1_button.pressed.connect(_on_chapter_button_press.bind(1))
	chapter_2_button.pressed.connect(_on_chapter_button_press.bind(2))
	chapter_3_button.pressed.connect(_on_chapter_button_press.bind(3))
	chapter_4_button.pressed.connect(_on_chapter_button_press.bind(4))
	chapter_5_button.pressed.connect(_on_chapter_button_press.bind(5))
	Signals.party_selected.connect(_on_party_select)

func _on_embark_button_pressed() -> void:
	between_runs_screen.visible = false
	chapter_select_screen.visible = true

func _on_chapter_button_press(chapter: int) -> void:
	selected_chapter = chapter
	chapter_select_screen.visible = false
	party_select_screen.visible = true
	
func _on_party_select(classes: Array[CharacterClass]) -> void:
	print(classes)
	party_select_screen.visible = false
