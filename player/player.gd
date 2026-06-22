extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
# variable realted to health
const MAX_HEALTH = 100
var health = MAX_HEALTH
var is_invincible = false
var invincibility_timer = 0.0
const INVINCIBILITY_DURATION = 1.0 
# when being hit
var knockback_timer = 0.0
var knockback_velocity = Vector2.ZERO
const KNOCKBACK_FRICTION = 0.6

@onready var anim = get_node("AnimatedSprite2D")
@onready var ladder_ray_cast = get_node("LadderRayCast")

func _ready() -> void:
	add_to_group("player")
	anim.play("idle")

func _physics_process(delta: float) -> void:
	# code related to knock back
	if knockback_velocity.length() > 5:
		velocity += knockback_velocity
		knockback_velocity *= KNOCKBACK_FRICTION  # decays each frame
		move_and_slide()
		_set_animation()
		return  
	else:
		knockback_velocity = Vector2.ZERO
		
	# code related to health	 
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0.0:
			is_invincible = false
	
	var ladderCollider = ladder_ray_cast.get_collider()
	
	if ladderCollider:
		_ladder_climb()
	else:
		_movement(delta)
	
	_set_animation()
	move_and_slide()

func _ladder_climb():
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		return 
	
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	anim.play("idle")
	if direction:
		velocity = direction * SPEED / 2
	else:
		velocity = Vector2.ZERO

func _movement(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animation
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")

func _set_animation() -> void:
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false

func take_damage(amount: int, knockback_direction: float = -1.0) -> void:
	if is_invincible:
		return
		
	health -= amount
	health = max(health, 0)
	is_invincible = true
	invincibility_timer = INVINCIBILITY_DURATION
	knockback_velocity = Vector2(knockback_direction * SPEED * 3.5, JUMP_VELOCITY * 0.17)
	#velocity.y = JUMP_VELOCITY
	
	print("Health: ", health)
	health = max(health, 0)
	get_tree().call_group("hud", "flash_damage")
	get_tree().call_group("hud", "update_health", health, MAX_HEALTH)
	if health <= 0:
		die()

func die() -> void:
	print("Player died!")
	set_physics_process(false)
	velocity = Vector2.ZERO
	anim.play("death")
	
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
