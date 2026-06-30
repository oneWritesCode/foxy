extends Node
signal get_key(new_total)
var key: int = 0

func add_key(amount: int) -> void:
	key += amount
	get_key.emit(key)
