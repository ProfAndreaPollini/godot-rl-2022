extends TextureRect
class_name InventoryItemIcon

var item = null




func _on_InventoryItemIcon_gui_input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
		EventBus.emit_signal("player_exchange_weapon",item)
