extends TextureRect



func _on_InventoryUIIcon_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			EventBus.emit_signal("open_inventory")
