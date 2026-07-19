extends TextureButton

@onready var btnClickSound = $"../../buttonClick"

var is_busy = false

@onready var level_1_button = $"../TextureRect/level 1 btn"
@onready var level_2_button = $"../TextureRect/level 2 btn"
@onready var level_overlay = $"../TextureRect"
@onready var play_btn = $"../play"

func _ready():
	level_overlay.visible = false

	level_1_button.pressed.connect(_on_level1_button_pressed)
	level_2_button.pressed.connect(_on_level2_button_pressed)
	play_btn.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
	if is_busy:
		return

	is_busy = true
	disabled = true

	btnClickSound.play()
	await btnClickSound.finished
	level_overlay.visible = true
	is_busy = false
	disabled = false

func _on_pressed():
	if is_busy:
		return

	is_busy = true
	disabled = true

	btnClickSound.play()
	await btnClickSound.finished

	get_tree().quit()

func _on_level1_button_pressed():
	if is_busy:
		return

	is_busy = true
	disabled = true

	btnClickSound.play()
	await btnClickSound.finished
	get_tree().change_scene_to_file("res://world.scn")

func _on_level2_button_pressed():
	if is_busy:
		return

	is_busy = true
	disabled = true

	btnClickSound.play()
	await btnClickSound.finished
	get_tree().change_scene_to_file("res://world2.tscn")
