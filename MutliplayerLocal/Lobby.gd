extends Control

const SERVER_IPV4 = "127.0.0.1"
const SERVER_PORT = 31600
const MAX_PLAYERS = 2

var player_info = {}
var myInfo = { name = "Client", favorite_color = Color8(34,139,34) }

func _ready() -> void:
	var _result
	_result = get_tree().connect("network_peer_connected", self, "_player_connected")
	_result = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_result = get_tree().connect("connected_to_server", self, "_connected_ok")
	_result = get_tree().connect("connection_failed", self, "_connected_fail")
	_result = get_tree().connect("server_disconnected", self, "_server_disconnected")

func _init_server() -> void:
	get_tree().network_peer = null
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	set_terminate_game_visibility(get_tree().is_network_server())

func _init_client() -> void:
	get_tree().network_peer = null
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IPV4, SERVER_PORT)
	get_tree().network_peer = peer
	
	self.set_network_master(get_tree().get_network_unique_id())
	set_terminate_game_visibility(get_tree().is_network_server())

func terminate_server() -> void:
	get_tree().network_peer = null
	set_terminate_game_visibility(get_tree().is_network_server())

func _player_connected(id) -> void:
	# Called on both clients and server when a peer connects. Send my info to it.
	print ("Player " + str(id) + " connected")

func _player_disconnected(id) -> void:
	player_info.erase(id) # Erase player from info.
	print ("Player " + str(id) + " disconnected")

func _connected_ok() -> void:
	print ("I connected as player " + str(get_tree().get_network_unique_id()))
	rpc_id(1,"register_player",myInfo)

func _server_disconnected() -> void:
	pass # Server kicked us; show error and abort.

func _connected_fail() -> void:
	pass # Could not even connect to server; abort.

remote func register_player(info) -> void:
	if get_tree().is_network_server():
		# Get the id of the RPC sender.
		var id = get_tree().get_rpc_sender_id()
		# Store the info
		player_info[id] = info
		rpc("refresh_player_info",player_info)

sync func refresh_player_info(_player_info) -> void:
	player_info = _player_info
	refresh_user_list(player_info)

##############################################

remote func refresh_user_list(_player_info) -> void:
	$HBoxContainer/UserList.clear()
	for info in _player_info:
		$HBoxContainer/UserList.add_item(_player_info[info].name)

func _set_info() -> void:
	if get_tree().is_network_server():
		myInfo = { name = "Server", favorite_color = Color8(34,139,34) }

func _on_Join_pressed() -> void:
	_init_client()
	_set_info()
	register_player(myInfo)

func _on_Create_pressed() -> void:
	_init_server()
	_set_info()
	register_player(myInfo)

func _on_TerminateGame_pressed() -> void:
	terminate_server()
	
func _on_StartGame_pressed():
	pass

func set_terminate_game_visibility(hosted_a_game : bool) -> void:
	$HBoxContainer/VBoxContainer/TerminateGame.visible = hosted_a_game
	$HBoxContainer/VBoxContainer/StartGame.visible = hosted_a_game

