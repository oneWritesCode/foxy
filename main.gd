extends Button
@onready var btnClickSound = $"../buttonClick"
var is_busy = false

func _on_pressed() -> void:
	if is_busy:
		return
	is_busy = true
	disabled = true
	btnClickSound.play()
	await btnClickSound.finished
	get_tree().quit()

func _on_play_pressed() -> void:
	if is_busy:
		return
	is_busy = true
	disabled = true
	btnClickSound.play()
	await btnClickSound.finished
	get_tree().change_scene_to_file("res://world.scn")
