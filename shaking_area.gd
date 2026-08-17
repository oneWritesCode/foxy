extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		var cam = get_tree().get_first_node_in_group("camera")
		print("shake")
		if cam:
			cam.shake(3.0, 0.5)  # intensity pixels, duration seconds
