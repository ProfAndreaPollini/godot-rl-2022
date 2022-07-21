extends Node


var capacity = 5

func has_free_slot() -> bool:
	return get_child_count() < capacity

func add_item(item):
	add_child(item)
	EventBus.emit_signal("pocket_modified")
