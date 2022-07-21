extends Item



func _ready():
	set_property("value",10)
	set_property("name","Piccola moneta")
	$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body):
	print("on coin")
	body.pick_coin(self)


func destroy():
	queue_free()
