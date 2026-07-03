extends Area2D

@onready var bg_music_when_playing = $"../AudioStreamPlayer"
var triggered = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if triggered:
		return
	if body.name != "player":
		return
	if Keys.key <= 0:
		return

	triggered = true
	body.set_physics_process(false)
	body.velocity = Vector2.ZERO
	bg_music_when_playing.stop()
	$"../CanvasLayer/HUD/WinScene/AudioStreamPlayer".play()
	body.anim.play("victory")
	await get_tree().create_timer(2.0).timeout
	get_tree().call_group("hud", "show_win_message")
