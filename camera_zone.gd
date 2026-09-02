extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var cam = body.get_node("Camera2D")
		var shape := collision_shape.shape as RectangleShape2D
		if shape == null:
			push_warning("cameraZone requires a RectangleShape2D")
			return

		var extents = shape.extents  # half-size of the rectangle
		var center = collision_shape.global_position

		cam.limit_left = int(center.x - extents.x)
		cam.limit_right = int(center.x + extents.x)
		cam.limit_top = int(center.y - extents.y)
		cam.limit_bottom = int(center.y + extents.y)
