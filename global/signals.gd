extends Node

# Network
@warning_ignore("unused_signal")
signal net_state_updated(state: Enums.NetState)
@warning_ignore("unused_signal")
signal peers_updated

# Host
@warning_ignore("unused_signal")
signal server_created
@warning_ignore("unused_signal")
signal server_closed
@warning_ignore("unused_signal")
signal client_connected(peer_id: int)
@warning_ignore("unused_signal")
signal client_disconnected(peer_id: int)

# Client
@warning_ignore("unused_signal")
signal connected_to_server
@warning_ignore("unused_signal")
signal disconnected_from_server
@warning_ignore("unused_signal")
signal connection_failed
@warning_ignore("unused_signal")
signal player_registry_updated

# Gameplay
@warning_ignore("unused_signal")
signal loaded_game
@warning_ignore("unused_signal")
signal turn_ended(character: Character)
@warning_ignore("unused_signal")
signal turn_started(character: Character)
@warning_ignore("unused_signal")
signal turn_order_change(characters: Array[Character])
 
 # Characters
@warning_ignore("unused_signal")
signal character_spawned(character: Character)
@warning_ignore("unused_signal")
signal character_died(character: Character)
