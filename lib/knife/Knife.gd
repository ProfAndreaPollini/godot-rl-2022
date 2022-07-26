extends Node2D

export(Texture) var icon_texture
export(NodePath)var entity

var direction = Vector2.ZERO
var is_firing :=false
var old_position := Vector2.ZERO

onready var fire_timer = $FireTimer
onready var tween  = $Tween

func _ready():
	add_to_group("weapon")


func on_mouse_moved(pos: Vector2,dir: Vector2):
	#print("On mouse moved pos = ", pos, " dir = ", dir)
	direction = dir 
	
	global_position = pos + 10*dir
	#print("pos(pre) = ",global_position)
	global_position.x = clamp(global_position.x,pos.x-5,pos.x+5)	
	global_position.y = clamp(global_position.y,pos.y-15,pos.y+15)
	
	look_at(global_position + 200*direction)
	
func shoot():
	if not is_firing:
		is_firing = true
		fire_timer.start()
		old_position = global_position
		#global_position = global_position + 10*direction
		tween.interpolate_property(self,
		"global_position",
		global_position,
		global_position + 10*direction,0.1,Tween.TRANS_QUAD
		)
		tween.start()
	
		
	


func _on_FireTimer_timeout():
	global_position = old_position
	is_firing = false
