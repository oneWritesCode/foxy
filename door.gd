extends Node2D

#@onready var label = $Label
@onready var speech_bubble = $Node2D
@onready var texture_rect = $Node2D/TextureRect
@onready var label = $Node2D/TextureRect/Label
@onready var area = $Area2D
var hide_timer = 0.0
var is_showing = false

var full_text = "the
door is locked"
var current_chars = 0
var typing_speed = 0.05  # seconds per character
var typing_timer = 0.0

func _ready():
	label.visible = false
	texture_rect.visible = false
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(delta):
	if is_showing and current_chars < full_text.length():
		typing_timer -= delta
		if typing_timer <= 0:
			current_chars += 1
			label.text = full_text.substr(0, current_chars)
			typing_timer = typing_speed
			
	if is_showing:
		hide_timer -= delta
		if hide_timer <= 0:
			label.visible = false
			texture_rect.visible = false
			is_showing = false

func _on_body_entered(body):
	if body.name == "player":
		label.visible = true
		texture_rect.visible = true
		label.text = ""
		current_chars = 0
		hide_timer = 10.0
		is_showing = true

func _on_body_exited(body):
	if body.name == "player":
		label.visible = false
		texture_rect.visible = false
		is_showing = false
