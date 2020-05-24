extends Control

func _ready() -> void:
	Resources.lobby = self
	
	var _result
	_result = get_tree().connect("network_peer_connected", self, "_player_connected")
	_result = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_result = get_tree().connect("connected_to_server", self, "_connected_ok")
	_result = get_tree().connect("connection_failed", self, "_connected_fail")
	_result = get_tree().connect("server_disconnected", self, "_server_disconnected")

func _host_game() -> void:
	get_tree().network_peer = null
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(Resources.SERVER_PORT,Resources.MAX_CLIENTS)
	get_tree().network_peer = peer

func _join_game() -> void:
	get_tree().network_peer = null
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(Resources.SERVER_IPV4,Resources.SERVER_PORT)
	get_tree().network_peer = peer

func _refresh_player_list(player_info) -> void:
	$HBoxContainer/VBoxLeft/Players.clear()
	for info in player_info:
		$HBoxContainer/VBoxLeft/Players.add_item(player_info[info]["alias"])

func _refresh_queued_list(queued_info) -> void:
	$HBoxContainer/VBoxRight/Queue.clear()
	for info in queued_info:
		$HBoxContainer/VBoxRight/Queue.add_item(queued_info[info]["alias"])

func _queue_empty() -> bool:
	return Resources.queued_info.size() == 0

func _game_full() -> bool:
	return Resources.player_info.size() >= Resources.MAX_PLAYERS

func _drain_queue() -> void:
	while not _game_full():
		var id = Resources.queued_info.keys().front()
		Resources.player_info[id] = Resources.queued_info[id]
		Resources.queued_info.erase(id)
		# TODO: rpc call to have client enter game and sync
	
	_sync_client_info()

func _player_connected(id) -> void:
	#print("player " + str(id) + " connected")
	pass
	
func _player_disconnected(id) -> void:
	#print("player " + str(id) + " disconnected")
	if get_tree().is_network_server():
		Resources.player_info.erase(id)
		Resources.queued_info.erase(id)
		_sync_client_info()

func _connected_ok() -> void:
	var info = { "alias": $HBoxContainer/VBoxCenter/textAlias.text }
	rpc("register_player",info)

func _connected_fail() -> void:
	$HBoxContainer/VBoxLeft/Players.clear()
	$HBoxContainer/VBoxLeft/Players.add_item("Connection Failed")

func _server_disconnected() -> void:
	_refresh_player_list({})
	_refresh_queued_list({})

func _on_Join_pressed() -> void:
	_join_game()

func _on_Create_pressed() -> void:
	_host_game()
	var info = { "alias": $HBoxContainer/VBoxCenter/textAlias.text }
	register_player(info,1)
	
	$HBoxContainer/VBoxCenter/Join.visible = false
	$HBoxContainer/VBoxCenter/StartGame.visible = true

func _on_timerQueue_timeout():
	if not _game_full():
		_drain_queue()
	
	if _queue_empty():
		$timerQueue.stop()

func _sync_client_info() -> void:
	if get_tree().is_network_server():
		rpc("sync_player_info",Resources.player_info)
		rpc("sync_queued_info",Resources.queued_info)

remote func register_player(info, id : int = 0) -> void:
	if id == 0: # Allows for local calls of this function
		id = get_tree().get_rpc_sender_id()
	
	if get_tree().is_network_server():
		if _game_full():
			Resources.queued_info[id] = info
			$timerQueue.start()
		else:
			Resources.player_info[id] = info
		
		_sync_client_info()

sync func sync_player_info(_player_info) -> void:
	Resources.player_info = _player_info
	_refresh_player_list(Resources.player_info)

sync func sync_queued_info(_queued_info) -> void:
	Resources.queued_info = _queued_info
	_refresh_queued_list(Resources.queued_info)

func _on_StartGame_pressed():
	Resources.level = preload("res://Level.tscn").instance()
	rpc("load_level")
	_sync_client_info()
	rpc("sync_players")

sync func load_level():
	if Resources.queued_info.has(get_tree().get_network_unique_id()):
		# Do no load level if you are in queue
		return
	
	if not Resources.level:
		Resources.level = preload("res://Level.tscn").instance()
	self.visible = false
	var game = get_parent()
	game.add_child(Resources.level)
	
	_init_players()

func _init_players():
	var play : KinematicBody2D
	for player in Resources.player_info:
		if Resources.player_instances.has(player):
			play = Resources.player_instances[player]
			Resources.level.add_child(play)
		else:
			play = preload("res://Player.tscn").instance()
			Resources.level.add_child(play)
			Resources.player_instances[player] = play
			play.alias = Resources.player_info[player]["alias"]
			play.master_id = player
			play.init_player(player)

remote func sync_players():
	for player in Resources.player_info:
		if Resources.player_instances.has(player):
			var play = Resources.player_instances[player]
			play.sync_player(player
					,Resources.player_info[player]["position"]
					,Resources.player_info[player]["alias"]
					,Resources.player_info[player]["frame"]
					,Resources.player_info[player]["flip_h"])

func _add_player():
	pass

