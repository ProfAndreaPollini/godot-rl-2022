extends Node


signal moved()
signal stopped()

export(float) var velocity = 100.0
onready var entity  = get_parent()
export(String) var group = ""

var is_moving := false setget set_is_moving, get_is_moving
var direction :=Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().add_to_group(group)

func set_is_moving(v):
	if not is_moving and v:
		emit_signal("moved")
		is_moving = v
	elif is_moving and not v:
		emit_signal("stopped")
		is_moving = v
	
	
func get_is_moving():
	return is_moving


func update(delta):
	var dx =  int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	var dy =  int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	var ds = Vector2(dx,dy).normalized()
	var moved = ds != Vector2.ZERO
	set_is_moving(moved)
	
	if moved:
		direction = ds
	
		entity.move_and_slide(direction * velocity) 
		EventBus.emit_signal("player_moved",dx,dy)
