extends Control

@onready var between_runs_screen: Control = %BetweenRunsScreen
@onready var party_select_screen: Control = %PartySelectionScreen

var selected_chapter: int

func _ready() -> void:
	Signals.party_selected.connect(_on_party_select)

func _on_embark_button_pressed() -> void:
	between_runs_screen.visible = false
	party_select_screen.visible = true

func _on_party_select(party: Party) -> void:
	party_select_screen.visible = false
	DataStore.party = party
	if (get_tree()):
		get_tree().change_scene_to_file("res://features/game_manager/gameplay/gameplay_manager.tscn")
