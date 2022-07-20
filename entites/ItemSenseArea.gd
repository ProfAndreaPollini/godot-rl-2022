extends Area2D


onready var entity = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("entity for sense area: ",entity)






func _on_ItemSenseArea_area_entered(area):
	if area.get_groups().has("potions"):
		area.is_close_to(entity)
		print(area)


func _on_ItemSenseArea_area_exited(area):
	if area.get_groups().has("potions"):
		area.is_not_close_to(entity)
