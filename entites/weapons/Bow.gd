extends Weapon

var Arrow := preload("res://entites/weapons/Arrow.tscn")

var CoolDown  = load("res://entites/weapons/CoolDown.gd")


var cool_down = CoolDown.new()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		self.shoot()
			
	if cool_down.is_firing:
		cool_down.increment_fire_time(delta)
		#print("fire_time = ",cool_down.fire_time)

	if cool_down.is_cooldown_ended():
		pass
		

func shoot():
	if not cool_down.can_fire(): return
	
	cool_down.start()
	var arrow = Arrow.instance()
	arrow.global_position = self.global_position + 10*direction
	arrow.look_at(global_position + 200*direction)
	arrow.direction = direction
	get_parent().add_child(arrow)


func on_mouse_moved(pos: Vector2,dir: Vector2):
	#print("On mouse moved pos = ", pos, " dir = ", dir)
	direction = dir
	
	global_position = pos + 10*dir
	#print("pos(pre) = ",global_position)
	global_position.x = clamp(global_position.x,pos.x-5,pos.x+5)	
	global_position.y = clamp(global_position.y,pos.y-15,pos.y+15)
	
	look_at(global_position + 200*direction)
	
	#rotate(deg2rad(90))
	
#	var weapon_position =  pos + 10*dir
#
#	global_position  = pos 
#	look_at(pos + 100*dir)
	#print("ANGLE = ",rotation)
	#print("pos = ",global_position)
	#rotate(deg2rad(90))
#	_draw()
#
#func _draw():
#	draw_circle(Vector2.ZERO,2,Color.rebeccapurple)

func _on_BodyArea_body_entered(entity):
	print("Bow: ",entity)
	equip_or_put_into_inventory(entity,self)
#	if entity.has_method("can_equip"):
#		if entity.can_equip(self):
#			get_parent().remove_child(self)
#			entity.add_weapon(self)
