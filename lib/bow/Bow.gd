extends Node2D


export(Texture) var icon_texture

var direction = Vector2.ZERO
var entity

# Called when the node enters the scene tree for the first time.
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
