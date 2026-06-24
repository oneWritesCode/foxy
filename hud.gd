extends Control

@onready var health_bar = $HealthBar
@onready var damage_overlay = $DamageOverlay
@onready var restart_button = $ButtonRow/RestartButton
@onready var quit_button = $ButtonRow/QuitButton
@onready var pause_button = $ButtonRow/PauseButton
@onready var pause_label = $PauseLabel

var damage_tween: Tween
var health_tween: Tween
	
func _ready() -> void:
	add_to_group("hud")
	damage_overlay.visible = false
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
	#health_label.text = "HP: %d / %d" % [current, max_health]
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", current, 0.5)

func flash_damage() -> void:
	if damage_tween:
		damage_tween.kill()
	damage_overlay.visible = true
	damage_overlay.modulate.a = 0.8
	damage_tween = create_tween()
	damage_tween.tween_interval(0.2)
	damage_tween.tween_property(damage_overlay, "modulate:a", 0.0, 1.0)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	pause_label.visible = get_tree().paused
	pause_button.text = "RESUME" if get_tree().paused else "PAUSE"
