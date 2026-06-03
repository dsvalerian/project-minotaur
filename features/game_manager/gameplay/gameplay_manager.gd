class_name GameplayManager extends Node2D

@onready var map_manager: MapManager = $MapManager
@onready var turn_manager: TurnManager = $TurnManager

var scaling_manager: ScalingManager = ScalingManager.new()
var current_floor: int = 1

var party: Party

var character_scene: PackedScene = preload("res://features/characters/character.tscn")
var c1: Character
var c2: Character
var c3: Character
var c4: Character

func _ready() -> void:
	party = DataStore.party
	
