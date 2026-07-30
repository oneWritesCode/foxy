extends Area2D

signal diamonds_changed(new_total)
var diamonds: int = 0

@export var diamond_type: String = "diamond_blue"

@onready var anim = $AnimatedSprite2D
@onready var diamond_sound = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	anim.play(diamond_type)

func _on_body_entered(body: Node) -> void:
	if body.name != "player":
		return
	Diamonds.add_diamond(1)
	anim.visible = false
	set_deferred("monitoring", false)
	diamond_sound.play()
	await diamond_sound.finished
	queue_free()
	
func add_diamond(amount: int) -> void:
	diamonds += amount
	diamonds_changed.emit(diamonds)
