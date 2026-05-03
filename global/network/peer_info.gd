class_name PeerInfo

var id: int
var name: String

func _init(_id: int, _name: String):
	id = _id
	name = _name

func serialize() -> Dictionary:
	return {"id": id, "name": name}

static func deserialize(dict: Dictionary) -> PeerInfo:
	return PeerInfo.new(dict["id"], dict["name"])
