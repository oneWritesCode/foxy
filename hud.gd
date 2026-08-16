extends Control

@onready var health_bar = $HealthBar
@onready var damage_overlay = $DamageOverlay
@onready var restart_button = $PauseTexture/RestartButton
#@onready var quit_button = $PauseTexture/QuitButton
@onready var home_button = $PauseTexture/HomeButton
@onready var settings_button = $settingsButton
@onready var paused_settings_page = $PauseTexture
@onready var btnClickSound = $"../buttonClick"
@onready var coin_label = $coinLabel
@onready var key_texture = $key
@onready var diamond_label = $DiamondHead/DiamondLabel
@onready var key_label = $keyLabel
@onready var win_scene = $WinScene
#@onready var win_label = $WinScene/winLabel
var damage_tween: Tween
var health_tween: Tween
#var win_label_text = "second level is 
#under construction,
#so,wait till then :)"
	
func _ready() -> void:
	add_to_group("hud")
	damage_overlay.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS   # keeps this whole HUD responsive even while paused

	restart_button.pressed.connect(_on_restart_button_pressed)
	#quit_button.pressed.connect(_on_quit_button_pressed)
	home_button.pressed.connect(_on_home_button_pressed)
	settings_button.pressed.connect(_on_pause_button_pressed)
	paused_settings_page.visible = false
	win_scene.visible = false

	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group("player")
	if player:
		update_health(player.health, player.MAX_HEALTH)
		
	# code for key
	Keys.get_key.connect(on_get_key)
	on_get_key(Keys.key)
	
	#code for conins
	Currency.coins_changed.connect(_on_coins_changed)
	_on_coins_changed(Currency.coins) 
	
	# for diamonds
	Diamonds.diamonds_changed.connect(_on_diamonds_changed)
	_on_diamonds_changed(Diamonds.diamonds)

func _on_diamonds_changed(new_total: int) -> void:
	diamond_label.text = "x%d" % new_total

func _on_coins_changed(new_total: int) -> void:
	coin_label.text = "*%d" % new_total

func on_get_key(new_total: int) -> void:
	key_label.text = "*%d" % new_total
	
func show_win_message() -> void:
	#bg_music_when_playing.stop()
	#$WinScene/AudioStreamPlayer.play()
	win_scene.visible = true
	#win_label.text = win_label_text
	#win_label.visible = true

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
	btnClickSound.play()
	get_tree().paused = false
	paused_settings_page.visible = false
	Keys.key = 0
	get_tree().reload_current_scene()

func _on_home_button_pressed() -> void:
	btnClickSound.play()
	#await btnClickSound.finished
	get_viewport().gui_release_focus()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

#func _on_quit_button_pressed() -> void:
	#btnClickSound.play()
	#get_tree().quit()

func _on_pause_button_pressed() -> void:
	btnClickSound.play()
	get_tree().paused = !get_tree().paused
	paused_settings_page.visible = get_tree().paused
