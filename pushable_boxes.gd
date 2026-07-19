extends CharacterBody2D

const GRAVITY = 900.0
const PUSH_SPEED = 60.0

@onready var box = $Sprite2D

var push_direction = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	velocity.x = push_direction * PUSH_SPEED
	
	if push_direction != 0:
		box = push_direction < 0
	
	push_direction = 0	
	move_and_slide()
