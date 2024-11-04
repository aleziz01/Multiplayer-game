extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var playerscene: PackedScene

func _on_host_pressed() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func add_player(id=1):
	var player=playerscene.instantiate()
	player.name=str(id)
	call_deferred("add_child",player)

func _on_connect_pressed() -> void:
	peer.create_client("localhost",135)
	multiplayer.multiplayer_peer = peer
