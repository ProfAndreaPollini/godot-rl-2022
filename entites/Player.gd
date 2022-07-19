extends Node

onready var owner_entity = get_parent().get_parent()

func _ready():
	print(owner_entity)


func _process(delta):
	var dx =  int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	var dy =  int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	
	owner_entity.move_and_slide(Vector2(dx,dy)*50)
	owner_entity.emit_signal("moved",dx,dy)
