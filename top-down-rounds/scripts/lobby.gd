extends Node2D

var peer = ENetMultiplayerPeer.new()

@export var playerscene: PackedScene

@onready var network: Node = $Network

func _on_host_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func add_player(id=1):
	var player=playerscene.instantiate()
	player.name=str(id)
	network.call_deferred("add_child",player)

func _on_connect_pressed() -> void:
	peer.create_client("localhost",135)
	multiplayer.multiplayer_peer = peer

func _on_leave_party_pressed() -> void:
	if not multiplayer.is_server() and network.get_child_count()>0:
		rpc("LeftParty")
		await get_tree().create_timer(0.01).timeout
		multiplayer.multiplayer_peer.disconnect_peer(1)

@rpc("any_peer")
func LeftParty():
	for i in network.get_child_count():
		if network.get_child(i).name==str(multiplayer.get_remote_sender_id()):
			network.get_child(i).dead=true
			get_child_or_null(network,i).queue_free()

func get_child_or_null(node,index:int):
	if node.get_child(index)==null:
		return
	else:
		return node.get_child(index)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
