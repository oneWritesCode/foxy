extends Area2D

@export var spikes_to_disable: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		_set_spikes_active(false)

func _on_body_exited(body: Node) -> void:
	if body.name == "player":
		_set_spikes_active(true)

func _set_spikes_active(active: bool) -> void:
	for spike in spikes_to_disable:
		spike.visible = active
		var col = spike.get_node_or_null("CollisionShape2D")
		if col:
			col.set_deferred("disabled", not active)
