extends "res://lib/Item.gd"



func _ready():
	set_property("value",100)
	$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body):
	print("on coin")
	body.pick_coin(self)
