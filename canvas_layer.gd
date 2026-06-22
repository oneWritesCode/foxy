extends CanvasLayer

func _ready() -> void:
	add_to_group("hud")
	$".".visible = true
	$HUD/DamageOverlay.visible = false

func flash_damage() -> void:
	$HUD/DamageOverlay.visible = true
	await get_tree().create_timer(0.35).timeout
	$HUD/DamageOverlay.visible = false
