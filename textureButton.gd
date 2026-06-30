extends TextureButton

#@onready var hover_overlay = $HoverOverlay
var hover_tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if hover_tween:
		hover_tween.kill()
	hover_tween = create_tween()
	#hover_tween.tween_property(hover_overlay, "modulate:a", 1.0, 0.15)

func _on_mouse_exited() -> void:
	if hover_tween:
		hover_tween.kill()
	hover_tween = create_tween()
	#hover_tween.tween_property(hover_overlay, "modulate:a", 0.0, 0.15)
