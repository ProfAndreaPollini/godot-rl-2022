extends State

onready var king = get_tree().get_current_scene().get_node("King")



	

	
func _physics_process(delta):
	#print("_pp: Idle")
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			switch_to("running")
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			print("Wheel up")

