extends Node2D

var Notification = preload("res://entites/gui/NotificationHud.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_mes_test"):
		$"/root/Debug".add_debug_message("Tutto funziona")
		
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_K:
			$DialogueLayer.set_process_input(true)
			$DialogueLayer.say(["Zetalè noi non siamo boomer, ", "noi apparteniamo alla Generazione X, noi siamo stati i figli degli anni '80: qui sono leon fuxioa sotto luci blu, ", "colori accesi, batterie elettroniche, Magnum PI, Miami Vice e abiti fighissimi!!!"])
		if event.scancode == KEY_L:
			$DialogueLayer.hide()
			
func _ready():
	EventBus.connect("pick_coin",self, "on_pick_coin")
	
	
func on_pick_coin(coin):
	print("on pick coin: ",coin)
	var notification = Notification.instance()
	notification.global_position = coin.global_position + Vector2(0,-20)
	notification.set_text("+{0}".format({0:coin.get_property("value")}))
	coin.destroy()
	add_child(notification)
	
	
	
