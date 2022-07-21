extends Node2D

var Component = preload("res://lib/ecs/Component.gd")
 
var components_cache = {}
onready var components = get_node("Components")

func get_component(name) -> Component: 
	return components_cache[name] as Component

func has_component(name)->bool:
	return components_cache.has(name)

func remove_component(name):
	var component = components_cache[name]
	components.remove_child(component)
	component.destroy()
