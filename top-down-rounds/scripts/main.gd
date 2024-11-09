extends Node2D

@export var playerScene:PackedScene
@onready var players: Node = $Players

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.is_server():
		var index=0
		for i in global.players:
			var currentPlayer=playerScene.instantiate()
			currentPlayer.name=str(global.players[i].id)
			print(currentPlayer.name)
			players.add_child(currentPlayer)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position
			index+=1
