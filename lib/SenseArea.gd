extends Area2D

export(Array,String)  var sensing_groups
export(NodePath) var entity
export(float,0,1000) var radius setget set_radius, get_radius

func _on_ItemSenseArea_area_entered(area):
	for group in sensing_groups:
		if area.is_in_group(group):
			area.is_close_to(entity)
			

func _on_ItemSenseArea_area_exited(area):
	for group in sensing_groups:
		if area.is_in_group(group):
			area.is_not_close_to(entity)
			
func set_radius(value):
	($SensingCircle.shape as CircleShape2D).radius = value
	radius = value
	
func get_radius():
	return radius
