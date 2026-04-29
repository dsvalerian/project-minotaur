extends Node
class_name TurnManager

var players: CharacterQueue
var enemies: CharacterQueue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = CharacterQueue.new()
	enemies = CharacterQueue.new()
	
	# testing
	players.append(WarriorPlayer.new())
	players.append(ClericPlayer.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run_round() -> void:
	# Player phase
	print("starting player phase for %d players" % [players.size()])
	players.reset()
	while not players.is_exhausted():
		var player = players.current()
		player.take_turn()
		players.advance()
	
	# Enemy phase
	print("starting enemy phase for %d enemies" % [enemies.size()])
	enemies.reset()
	while not enemies.is_exhausted():
		var enemy = enemies.current()
		enemy.take_turn()
		enemies.advance()
