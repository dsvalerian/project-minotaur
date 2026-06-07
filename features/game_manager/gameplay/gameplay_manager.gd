class_name GameplayManager extends Node2D

@onready var hud_root: Control = $HUD/HudRoot
@onready var map_manager: MapManager = $MapManager
@onready var turn_manager: TurnManager = $TurnManager

var scaling_manager: ScalingManager = ScalingManager.new()
var current_floor: int = 1
var map_seed: int = 69420

var party: Party
var current_player: Character

func _ready() -> void:
	party = DataStore.party
	var map_size: Vector2i = scaling_manager.get_floor_size(current_floor)
	Signals.turn_order_change.connect(_on_turn_order_change)
	map_manager.map_width = map_size.x
	map_manager.map_height = map_size.y
	map_manager.map_seed = map_seed
	map_manager.create_map()
	spawn_characters()

func spawn_characters() -> void:
	add_child(party.p1)
	add_child(party.p2)
	add_child(party.p3)
	add_child(party.p4)

func _on_turn_order_change(characters: Array[Character]):
	if (!characters.is_empty()):
		current_player = characters[0]
	else:
		current_player = null

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2i = get_global_mouse_position()
	var tile_pos: Vector2i = map_manager.map_scene.floor_layer.local_to_map(mouse_pos)
	if (map_manager.character_can_move_to(current_player, tile_pos)):
		var player_pos: Vector2i = map_manager.get_character_pos(current_player)
		map_manager.render_path(player_pos, tile_pos)

func _input(event: InputEvent) -> void:
	if (!event.is_action_pressed("move")):
		return
	var mouse_pos: Vector2i = get_global_mouse_position()
	var tile_pos: Vector2i = map_manager.map_scene.floor_layer.local_to_map(mouse_pos)
	if (map_manager.character_can_move_to(current_player, tile_pos)):
		var player_pos: Vector2i = map_manager.get_character_pos(current_player)
		Signals.character_move.emit(current_player, player_pos, tile_pos)
