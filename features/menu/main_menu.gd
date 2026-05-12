extends Control
class_name MainMenu

func _ready():
	pass

func _on_click_play():
	get_tree().change_scene_to_file("res://features/map/map_manager.tscn")

func _on_click_multiplayer():
	get_tree().change_scene_to_file("res://features/lobby/ui/lobby_ui.tscn")

func _on_click_quit():
	get_tree().quit()
