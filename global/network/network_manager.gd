extends Node

const MAX_PLAYERS = 4

var peer: ENetMultiplayerPeer
	
### Host ###
func create_server(port: int) -> void:
	print("Creating server on port %d..." % port)
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	Signals.net_state_updated.emit(Enums.NetState.CONNECTED)
	Signals.server_created.emit()
	print("Created server")

func close_server() -> void:
	print("Closing server...")
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	
	multiplayer.peer_connected.disconnect(_on_peer_connected)
	multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)
	
	Signals.server_closed.emit()
	Signals.net_state_updated.emit(Enums.NetState.OFFLINE)
	print("Closed server")
	
func _on_peer_connected(peer_id: int) -> void:
	print("Peer %d connected" % peer_id)
	Signals.client_connected.emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer %d disconnected" % peer_id)
	Signals.client_disconnected.emit(peer_id)

### Client ###
func connect_to_server(address: String, port: int) -> void:
	if address.is_empty() or port == 0:
		print("Address or port not provided")
		return
		
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	Signals.net_state_updated.emit(Enums.NetState.CONNECTING)
	print("Connecting to server at %s:%d..." % [address, port])
	
func disconnect_from_server() -> void:
	print("Disconnecting from server...")
	multiplayer.multiplayer_peer.close()

func _on_connected_to_server() -> void:
	print("Connected to server")
	Signals.connected_to_server.emit()
	Signals.net_state_updated.emit(Enums.NetState.CONNECTED)
	
func _on_connection_failed() -> void:
	print("Failed to connect to server")
	Signals.connection_failed.emit()
	Signals.net_state_updated.emit(Enums.NetState.OFFLINE)
	
func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
		
	multiplayer.connected_to_server.disconnect(_on_connected_to_server)
	multiplayer.connection_failed.disconnect(_on_connection_failed)
	multiplayer.server_disconnected.disconnect(_on_server_disconnected)

	print("Disconnected from server")
	Signals.disconnected_from_server.emit()
	Signals.net_state_updated.emit(Enums.NetState.OFFLINE)
	
### Host+Client ###
func is_online() -> bool:
	return multiplayer.multiplayer_peer != null \
		and multiplayer.multiplayer_peer is not OfflineMultiplayerPeer
	
func is_server() -> bool:
	return is_online() and multiplayer.is_server()
	
func is_client() -> bool:
	return is_online() and not multiplayer.is_server()
