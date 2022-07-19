extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_firing := false
var old_global_position := Vector2.ZERO
var COOLDOWN_TIME := 0.1
var fire_time := 0.0

onready var owner_entity = null#get_parent().get_parent()

func on_mouse_moved(king: Vector2,event: Vector2):
	self.global_position = king + (king - event).normalized() * -3
	look_at( event )
	rotate(deg2rad(90))

func _process(delta):
	if not owner_entity: return
	
	if Input.is_action_just_pressed("ui_accept") and not is_firing:
		fire_time = delta
		is_firing = true
		old_global_position = global_position
		global_position += 10*owner_entity.direction
	elif Input.is_action_pressed("ui_accept") and is_firing:
		fire_time += delta 
	elif Input.is_action_just_released("ui_accept") and fire_time > COOLDOWN_TIME:
		is_firing = false
		global_position = old_global_position

func _on_Sword_body_entered(entity):
	if entity.can_equip(self):
		get_parent().remove_child(self)
		entity.add_weapon(self)
