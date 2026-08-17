extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var col = $CollisionShape2D
@onready var area = $Area2D

var is_gone = false

@export var min_time: float = 0.2
@export var max_time: float = 4.0

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		_vanish()

func _vanish() -> void:
	if is_gone:
		return
	is_gone = true
	# Pick a random time between min_time and max_time
	var disappear_time = randf_range(min_time, max_time)
	print("Tile will disappear in: ", disappear_time, " seconds")
	# Wait before disappearing
	await get_tree().create_timer(disappear_time).timeout
	sprite.visible = false
	col.set_deferred("disabled", true)
	# Stay gone for 4 seconds
	await get_tree().create_timer(4.0).timeout
	# Come back
	sprite.visible = true
	col.set_deferred("disabled", false)
	is_gone = false
