extends SenseArea



func _on_Hitbox_body_entered(body):
	var parent_position = get_parent().global_position
	var direction =  get_parent().direction
	print("hit ",body)
	#body.global_position = body.global_position.move_toward( parent_position + 50*direction,30)
	#body.look_at(body.global_position + 50*direction)
	body.move_and_collide(5*direction)
	body.emit_signal("hit")
