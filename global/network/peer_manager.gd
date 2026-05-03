extends Node

var store = PeerStore.new({})

func _ready() -> void:
	# Host
	Signals.client_connected.connect(_add_client_peer)
	Signals.client_disconnected.connect(_remove_client_peer)
	Signals.server_created.connect(_on_server_created)
	Signals.server_closed.connect(_on_server_closed)
	
	# Client
	Signals.connected_to_server.connect(_on_connected_to_server)
	Signals.disconnected_from_server.connect(_on_disconnected_from_server)

### Host ###
func _add_client_peer(peer_id: int) -> void:
	store.put(PeerInfo.new(peer_id, "Player %d" % peer_id))
	_sync_peers_rpc.rpc(store.serialize())

func _remove_client_peer(peer_id: int) -> void:
	store.remove(peer_id)
	_sync_peers_rpc.rpc(store.serialize())
	
func _on_server_created() -> void:
	store.put(PeerInfo.new(multiplayer.get_unique_id(), "Host"))
	_sync_peers_rpc.rpc(store.serialize())
	
func _on_server_closed() -> void:
	store.clear()
	_sync_peers_rpc.rpc(store.serialize())
	
### Client ###
func _on_connected_to_server() -> void:
	# todo use for sending additional player info after connected
	pass
	
func _on_disconnected_from_server() -> void:
	store.clear()
	Signals.peers_updated.emit()

### Host+Client ###
@rpc("authority", "call_local", "reliable")
func _sync_peers_rpc(peers: Dictionary) -> void:
	store = PeerStore.deserialize(peers)
	Signals.peers_updated.emit()
	print("Synced %d peers" % store.size())
