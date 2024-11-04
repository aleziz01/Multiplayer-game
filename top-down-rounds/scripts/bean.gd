extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dead=false

func _physics_process(_delta: float) -> void: 
	if is_multiplayer_authority() and !dead:
		velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 400
	move_and_slide()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	$Name.text=name
