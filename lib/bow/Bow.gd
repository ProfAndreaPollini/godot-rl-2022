extends Node2D


export(Texture) var icon_texture

var direction = Vector2.ZERO
export(NodePath)var entity

var Arrow = preload("res://entites/weapons/Arrow.tscn")

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


func shoot():
	#if not cool_down.can_fire(): return
	
	#cool_down.start()
	var arrow = Arrow.instance()
	arrow.global_position = self.global_position + 1*direction
	arrow.look_at(global_position + 200*direction)
	arrow.direction = direction
	get_node(entity).get_parent().add_child(arrow)


func _on_BodyArea_body_entered(body):
	print("{0} is on bow".format({0:body}))
	EventBus.emit_signal("player_on_weapon",self)
