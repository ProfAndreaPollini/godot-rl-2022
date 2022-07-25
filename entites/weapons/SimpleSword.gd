extends Weapon





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SwordArea_body_entered(entity):
	equip_or_put_into_inventory(entity,self)
		
