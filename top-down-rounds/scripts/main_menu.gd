extends Node2D

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_leave_pressed() -> void:
	get_tree().quit()
