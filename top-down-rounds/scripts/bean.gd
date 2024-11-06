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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		Shoot()

func Shoot():
	pass
