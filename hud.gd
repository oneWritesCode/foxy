extends Control

@onready var health_bar = $HealthBar
@onready var damage_overlay = $DamageOverlay
@onready var restart_button = $ButtonRow/RestartButton
@onready var quit_button = $ButtonRow/QuitButton
@onready var pause_button = $ButtonRow/PauseButton
@onready var pause_label = $PauseLabel

func _ready() -> void:
	add_to_group("hud")
	process_mode = Node.PROCESS_MODE_ALWAYS   # keeps this whole HUD responsive even while paused

	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)

	pause_label.visible = false

	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group("player")
	if player:
		update_health(player.health, player.MAX_HEALTH)

func update_health(current: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current

func flash_damage() -> void:
	damage_overlay.color.a = 0.4
	var tween = create_tween()
	tween.tween_property(damage_overlay, "color:a", 0.0, 0.3)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	pause_label.visible = get_tree().paused
	pause_button.text = "RESUME" if get_tree().paused else "PAUSE"
