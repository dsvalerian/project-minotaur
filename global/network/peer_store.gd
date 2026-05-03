class_name PeerStore

var peers: Dictionary

func _init(_peers: Dictionary) -> void:
	peers = _peers

func put(peer: PeerInfo) -> void:
	peers[peer.id] = peer

func remove(peer_id: int) -> void:
	peers.erase(peer_id)

func clear() -> void:
	peers.clear()
	
func size() -> int:
	return peers.size()

func serialize() -> Dictionary:
	var serialized = {}
	for peer_id in peers:
		serialized[peer_id] = peers[peer_id].serialize()
		
	return serialized
	
static func deserialize(dict: Dictionary) -> PeerStore:
	var deserialized = {}
	for peer_id in dict:
		deserialized[peer_id] = PeerInfo.deserialize(dict[peer_id])
		
	return PeerStore.new(deserialized)
