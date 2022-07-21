extends "res://lib/ecs/Entity.gd"
class_name Item

var properties = {}

func has_property(name)-> bool:
	return properties.has(name)
	
func get_property(name):
	return properties[name]
	
func set_property(name,value):
	if has_property(name):
		properties[name] = value
