extends Control
class_name Lobby

@onready var host_join_menu: VBoxContainer = $HostJoinMenu
@onready var host_menu: VBoxContainer = $HostMenu
@onready var join_menu: VBoxContainer = $JoinMenu
@onready var lobby_menu: VBoxContainer = $LobbyMenu
@onready var host_port: LineEdit = $HostMenu/PortEdit
@onready var join_address: LineEdit = $JoinMenu/ServerInput/AddressEdit
@onready var join_port: LineEdit = $JoinMenu/ServerInput/PortEdit
@onready var player_list: ItemList = $LobbyMenu/PlayerList
@onready var start_game_button: Button = %StartGameButton

func _ready() -> void:
	_open_host_join_menu()
	
	Signals.net_state_updated.connect(_on_net_state_updated)
	Signals.peers_updated.connect(_update_player_list)
	var arguments = OS.get_cmdline_args()
	if ("--p1" in arguments):
		NetworkManager.create_server(9999)
	elif ("--p2" in arguments or "--p3" in arguments or "--p4" in arguments):
		NetworkManager.connect_to_server("localhost", 9999)

func _open_host_join_menu() -> void:
	host_menu.visible = false
	host_join_menu.visible = true
	join_menu.visible = false
	lobby_menu.visible = false
	
func _open_host_menu() -> void:
	host_menu.visible = true
	host_join_menu.visible = false
	join_menu.visible = false
	lobby_menu.visible = false
	
func _open_join_menu() -> void:
	host_menu.visible = false
	host_join_menu.visible = false
	join_menu.visible = true
	lobby_menu.visible = false

func _open_lobby_menu() -> void:
	host_menu.visible = false
	host_join_menu.visible = false
	join_menu.visible = false
	lobby_menu.visible = true
	if (NetworkManager.is_server()):
		start_game_button.visible = true
	if (!NetworkManager.is_server()):
		start_game_button.disabled = true;
	
func _update_player_list() -> void:
	player_list.clear()
	for peer_id in PeerManager.store.peers:
		player_list.add_item(PeerManager.store.peers[peer_id].name)

func _host_game() -> void:
	NetworkManager.create_server(host_port.text.to_int())

func _join_game() -> void:
	NetworkManager.connect_to_server(join_address.text, join_port.text.to_int())
	
func _disconnect() -> void:
	if NetworkManager.is_server():
		NetworkManager.close_server()
	elif NetworkManager.is_client():
		NetworkManager.disconnect_from_server()

func _on_net_state_updated(state: Enums.NetState) -> void:
	if state == Enums.NetState.CONNECTED:
		_open_lobby_menu()
	elif state == Enums.NetState.OFFLINE:
		_open_host_join_menu()

func _on_start_game_button_pressed() -> void:
	pass
