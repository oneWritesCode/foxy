extends Area2D
@export var limit_left: int
@export var limit_right: int
@export var limit_top: int
@export var limit_bottom: int

func _on_body_entered(body):
	if body.name == "player":
		var cam = body.get_node("Camera2D")
		cam.limit_left = limit_left
		cam.limit_right = limit_right
		cam.limit_top = limit_top
		cam.limit_bottom = limit_bottom
