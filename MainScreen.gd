extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_mes_test"):
		$"/root/Debug".add_debug_message("Tutto funziona")
