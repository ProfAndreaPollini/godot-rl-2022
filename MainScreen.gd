extends Node2D

var Notification = preload("res://entites/gui/NotificationHud.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_mes_test"):
		$"/root/Debug".add_debug_message("Tutto funziona")

func _ready():
	EventBus.connect("pick_coin",self, "on_pick_coin")
	
func on_pick_coin(coin):
	print("on pick coin: ",coin)
	var notification = Notification.instance()
	notification.global_position = coin.global_position + Vector2(0,-20)
	notification.set_text("+100")
	add_child(notification)
	
	
