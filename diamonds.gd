extends Node

signal diamonds_changed(new_total)
var diamonds: int = 0

func add_diamond(amount: int) -> void:
	diamonds += amount
	diamonds_changed.emit(diamonds)
