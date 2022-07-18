extends State


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			switch_to("idle")
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			print("Wheel up")
