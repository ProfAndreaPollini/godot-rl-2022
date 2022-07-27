extends Node

onready var toggle

func setup(context) -> void:
	toggle = get_parent().get_parent().get_node(context.get("toggle"))


func check() -> bool:
	
	if toggle.is_toggled:
		print("toggled")
	else:
		print("not toggled")
	return toggle.is_toggled
		
