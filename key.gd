extends Area2D

@export var value: int = 1
@onready var anim = $AnimatedSprite2D
#@onready var key_sound = $AudioStreamPlayer

func _ready() -> void:
	anim.play("shines")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		Keys.add_key(value)
		anim.visible = false
		#set_deferred("monitoring", false)
		#coin_sound.play()
		#await coin_sound.finished
		queue_free()
