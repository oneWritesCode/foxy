extends Button
@onready var btnClickSound = $"../buttonClick"
func _on_pressed() -> void:
	btnClickSound.play()
	await btnClickSound.finished
	get_tree().quit()

func _on_play_pressed() -> void:
	btnClickSound.play()
	await btnClickSound.finished
	get_tree().change_scene_to_file("res://world.scn")
