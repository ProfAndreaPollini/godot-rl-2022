extends "res://lib/ecs/Entity.gd"
class_name Weapon

onready var owner_entity = null #get_parent().get_parent()
var direction = Vector2.ZERO

var is_firing := false
var old_global_position := Vector2.ZERO

export(Texture)  var icon_texture = null

func on_mouse_moved(pos: Vector2,dir: Vector2):
	direction = dir
	var weapon_position =  pos + 10*dir
	
	global_position  = pos
	look_at(pos + 100*dir)
	rotate(deg2rad(90))

func _process(delta):
	if not owner_entity: return
	
#	if Input.is_action_just_pressed("ui_accept") and not is_firing:
#		#fire_time = delta
#		is_firing = true
#		old_global_position = global_position
#		global_position += 10*owner_entity.direction
#	elif Input.is_action_pressed("ui_accept") and is_firing:
#		pass #fire_time += delta 
#	elif Input.is_action_just_released("ui_accept"): #and fire_time > COOLDOWN_TIME:
#		is_firing = false
#		global_position = old_global_position


func equip_or_put_into_inventory(entity,obj):
	print("{0} try to get: {1}".format({0:entity,1:obj}))
	if entity.can_equip(obj):
		obj.get_parent().remove_child(obj)
		entity.add_weapon(obj)
		
	elif entity.inventory.has_free_slot():
		obj.get_parent().remove_child(obj)
		entity.inventory.add_item(obj)
		obj.visible = false
