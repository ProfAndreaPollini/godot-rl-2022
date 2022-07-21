extends Node

onready var owner_entity = get_parent().get_parent()

func _ready():
	print(owner_entity)
	if not owner_entity.is_in_group("player"):
		owner_entity.add_to_group("player")
	connect("child_exiting_tree",self,"on_destroy")

func on_destroy():
	if  owner_entity.is_in_group("player"):
		owner_entity.remove_from_group("player")


func _process(_delta):
	var dx =  int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	var dy =  int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	
	owner_entity.move_and_slide(Vector2(dx,dy)*50)
	owner_entity.emit_signal("moved",dx,dy)
