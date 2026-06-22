extends CharacterBody2D

enum State { PATROL, ALERT, ATTACK, RETURN }

const ATTACK_SPEED = 300.0
const TELEGRAPH_TIME = 0.4
const ATTACK_INTERVAL = 5.0
const RETURN_SPEED = 350.0
const HOME_SNAP_DIST = 5.0
const DAMAGE = 10
const KNOCKBACK_FORCE = 400.0

@onready var anim = $AnimatedSprite2D
@onready var detection_area = $watchzone
@onready var touch_hitbox = $touchhitbox
@onready var eagle_roar_sound = $AudioStreamPlayer

var state = State.PATROL
var target_position = Vector2.ZERO
var home_position = Vector2.ZERO
var player_ref = null
var player_in_detection_zone = false
var player_touching_body = false

func _ready() -> void:
	home_position = global_position
	anim.play("fly")
	detection_area.body_entered.connect(_on_detection_entered)
	detection_area.body_exited.connect(_on_detection_exited)
	touch_hitbox.body_entered.connect(_on_touch_entered)
	touch_hitbox.body_exited.connect(_on_touch_exited)

func _physics_process(delta: float) -> void:
	match state:
		State.RETURN:
			_move_toward_home()
		_:
			pass
	_check_touch_damage()
	move_and_slide()

func _on_detection_entered(body: Node) -> void:
	if body.name == "player":
		player_ref = body
		player_in_detection_zone = true
		if state == State.PATROL:
			_start_attack_cycle()

func _on_detection_exited(body: Node) -> void:
	if body.name == "player":
		player_in_detection_zone = false

func _on_touch_entered(body: Node) -> void:
	if body.name == "player":
		player_ref = body
		player_touching_body = true

func _on_touch_exited(body: Node) -> void:
	if body.name == "player":
		player_touching_body = false

func _check_touch_damage() -> void:
	if player_touching_body and is_instance_valid(player_ref):
		_hit_player()

func _start_attack_cycle() -> void:
	state = State.ALERT
	while player_in_detection_zone and is_instance_valid(player_ref):
		var cycle_start = Time.get_ticks_msec()
		await _do_one_attack()
		var elapsed_sec = (Time.get_ticks_msec() - cycle_start) / 1000.0
		var remaining = max(ATTACK_INTERVAL - elapsed_sec, 0.0)
		if remaining > 0.0:
			await get_tree().create_timer(remaining).timeout
	state = State.PATROL
	anim.play("fly")

func _do_one_attack() -> void:
	state = State.ALERT
	eagle_roar_sound.play()
	anim.play("alert")
	await get_tree().create_timer(TELEGRAPH_TIME).timeout

	if not is_instance_valid(player_ref):
		return

	target_position = player_ref.global_position
	var dir = (target_position - global_position).normalized()
	velocity = dir * ATTACK_SPEED
	anim.flip_h = dir.x < 0
	anim.play("attack")
	state = State.ATTACK

	while state == State.ATTACK:
		if global_position.distance_to(target_position) < 10.0 or velocity.length() < 1.0:
			break
		await get_tree().process_frame

	velocity = Vector2.ZERO
	state = State.RETURN
	anim.play("fly")

	while global_position.distance_to(home_position) > HOME_SNAP_DIST:
		await get_tree().process_frame

	global_position = home_position
	velocity = Vector2.ZERO

func _move_toward_home() -> void:
	var to_home = home_position - global_position
	if to_home.length() <= HOME_SNAP_DIST:
		velocity = Vector2.ZERO
	else:
		velocity = to_home.normalized() * RETURN_SPEED
		anim.flip_h = to_home.x > 0

func _hit_player() -> void:
	var knockback_dir = (player_ref.global_position - global_position).normalized()
	if player_ref.has_method("take_damage"):
		player_ref.take_damage(DAMAGE, sign(knockback_dir.x))
