extends Camera2D
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var original_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	limit_left = -100
	limit_top = 60
	limit_right = 1900
	limit_bottom = 650

func shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration

func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_duration -= delta
		offset = original_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = original_offset
		shake_intensity = 0.0
