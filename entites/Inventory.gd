extends Node


var capacity := 8


func has_free_slot() -> bool:
	return get_child_count() < capacity

func add_item(item):
	add_child(item)
	EventBus.emit_signal("inventory_modified")
