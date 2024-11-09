extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dead=false

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta: float) -> void:
	if multiplayer_synchronizer.get_multiplayer_authority()==multiplayer.get_unique_id():
		velocity = Input.get_vector("left","right","up","down") * 400
		look_at(get_global_mouse_position())
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		Shoot()

@onready var parent=get_parent()
var bullet=preload("res://scenes/bullet.tscn")

func Shoot():
	if multiplayer_synchronizer.get_multiplayer_authority()==multiplayer.get_unique_id():
		var bulletInstance=bullet.instantiate()
		bulletInstance.dir=Vector2(cos(rotation),sin(rotation))
		bulletInstance.global_position=global_position
		bulletInstance.rotation=rotation
		bulletInstance.parent=self
		parent.add_child(bulletInstance,true)

var hp=4
func takeDamage():
	hp-=1
	if hp<=0:
		die()

@rpc("any_peer","call_local")
func die():
	pass
