extends Area2D

@export var exit_position: Vector2   # set this in Inspector to the other teleporter's world position
@export var black_overlay: CanvasLayer  # drag your overlay node here

var is_cooling_down = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name != "player" or is_cooling_down:
		return
	is_cooling_down = true
	_teleport(body)

func _teleport(player: Node) -> void:
	# freeze player during transition
	player.set_physics_process(false)
	player.velocity = Vector2.ZERO

	# fade to black
	var overlay = black_overlay.get_node("ColorRect")
	overlay.visible = true
	overlay.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.4)
	await tween.finished

	# move player while screen is black
	player.global_position = exit_position

	# brief hold, then fade back in
	await get_tree().create_timer(0.2).timeout
	tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 0.4)
	await tween.finished

	overlay.visible = false
	player.set_physics_process(true)

	# cooldown so player doesn't instantly reteleport on arrival
	await get_tree().create_timer(1.0).timeout
	is_cooling_down = false
