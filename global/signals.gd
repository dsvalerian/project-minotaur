extends Node

# Network
signal net_state_updated(state: Enums.NetState)
signal peers_updated
# Host
signal server_created
signal server_closed
signal client_connected(peer_id: int)
signal client_disconnected(peer_id: int)
# Client
signal connected_to_server
signal disconnected_from_server
signal connection_failed

signal player_registry_updated
