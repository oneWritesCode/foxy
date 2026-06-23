extends Area2D
const DAMAGE = 10
@onready var player = $"../player"
@onready var strike_spike_sound = $strikeSpikeSound

var player_touching = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if player_touching:
		_check_damage()

func _on_body_entered(body) -> void:
	if body.name == "player":
		player_touching = true
		_check_damage()

func _on_body_exited(body) -> void:
	if body.name == "player":
		player_touching = false

func _check_damage() -> void:
	if not player.is_invincible:
		var direction = sign(player.global_position.x - global_position.x)
		strike_spike_sound.play()
		player.take_damage(DAMAGE, direction)
