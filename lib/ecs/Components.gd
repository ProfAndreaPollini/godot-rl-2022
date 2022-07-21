extends Node

onready var entity := get_parent()

func _ready():
	print("Entity: ",entity)
	
#	connect("child_exiting_tree",self,"on_destroy")
#
#func on_destroy():
#	if  owner_entity.is_in_group("player"):
#		owner_entity.remove_from_group("player")
		
		
func add(component):
	
	#add component to entity componetn cache
	entity.components[name.to_lower()] = self
	
	# add component groups to entity 
	for group in component.get_groups():
		if not entity.is_in_group(group):
			entity.add_to_group(group)
