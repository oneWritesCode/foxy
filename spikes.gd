extends Area2D

const DAMAGE = 10
@onready var player = $"../player"
@onready var strike_spike_sound =  $strikeSpikeSound
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if body.name == "player":
		var direction = sign(player.global_position.x - global_position.x)
		strike_spike_sound.play()
		body.take_damage(DAMAGE, direction)
