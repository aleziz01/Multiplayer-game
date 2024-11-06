extends Node2D

@export var port=8910
var peer
@onready var Name: LineEdit = $ConnectGUI/Name
@onready var ip: LineEdit = $ConnectGUI/Ip
@onready var connect_gui: Node2D = $ConnectGUI

func _ready() -> void:
	multiplayer.peer_connected.connect(playerConnected)
	multiplayer.peer_disconnected.connect(playerDisconnected)
	multiplayer.connected_to_server.connect(connectedToServer)
	multiplayer.connection_failed.connect(connectionFailed)

func playerConnected(id):
	print("Player " + str(id) + " connected")

func playerDisconnected(id):
	print("Player " + str(id) + " disconnected")
	if id==1:
		goBack.rpc()
		return
	global.players.erase(id)
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func connectedToServer():
	print("Connected")
	sendPlayerInfo.rpc_id(1, Name.text, multiplayer.get_unique_id())

@rpc("any_peer")
func sendPlayerInfo(theName,id):
	if !global.players.has(id):
		global.players[id]={
			"name": theName,
			"id":id,
			"rank":0
		}
	if multiplayer.is_server():
		for i in global.players:
			sendPlayerInfo.rpc(global.players[i].name,i)

func connectionFailed():
	print("Connection failed")

func _on_host_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	var error=peer.create_server(port,4)
	if error!=OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) #for a longer range
	multiplayer.set_multiplayer_peer(peer)
	sendPlayerInfo(Name.text, multiplayer.get_unique_id())

func _on_connect_to_server_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip.text, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

@rpc("any_peer","call_local")
func startGame():
	var mainScene=load("res://scenes/main.tscn").instantiate()
	get_tree().root.add_child(mainScene)
	hide()

func _on_start_game_pressed() -> void:
	startGame.rpc()

func _on_connect_pressed() -> void:
	connect_gui.visible=!connect_gui.visible

func _on_leave_party_pressed() -> void:
	leaveParty.rpc(peer.get_unique_id())

@rpc("any_peer","call_local")
func leaveParty(id):
	if multiplayer.is_server():
		peer.disconnect_peer(id)

@rpc("any_peer","call_local")
func goBack():
	global.players.clear()
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		i.queue_free()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
