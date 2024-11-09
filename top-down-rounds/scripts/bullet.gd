extends Node2D

var dir=Vector2.ZERO
var speed=600

func _process(delta: float) -> void:
	position+=delta*dir*speed

var parent=Node.new()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body!=parent and body.has_method("takeDamage"):
		body.takeDamage()

func _on_timer_timeout() -> void:
	#queue_free()
	pass
