extends MarginContainer

var InventoryItemIcon = preload("res://lib/ui/InventoryItemIcon.tscn")

onready var icons_container = $"%GridContainer"

func show_item(item):
	var item_ui = InventoryItemIcon.instance()
	item_ui.item = item
	item_ui.texture = item.icon_texture
	icons_container.add_child(item_ui)
	


