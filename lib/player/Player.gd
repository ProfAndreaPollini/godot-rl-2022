extends KinematicBody2D

var Bow = preload("res://lib/bow/Bow.tscn")

onready var movement = $KinematicMovementComponent

onready var weapon_position = $WeaponPosition

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

onready var weapon = $Bow

var is_moving := false

# Called when the node enters the scene tree for the first time.
func _ready():
	movement.connect("moved",self,"on_moved")
	movement.connect("stopped",self,"on_stopped")
	animation_state.travel("idle")


func _physics_process(delta):
	movement.update(delta)
	var mouse_position = get_global_mouse_position()
	movement.direction = (mouse_position - get_weapon_position()).normalized()
	
	
	var animation_param = movement.direction 
	
	animation_tree.set("parameters/idle/blend_position", animation_param)
	animation_tree.set("parameters/walk/blend_position", animation_param)
	if weapon:
		weapon.on_mouse_moved(mouse_position,animation_param)

func on_stopped():
	animation_state.travel("idle")
	is_moving = false

func on_moved():
	print("moved: ",movement.direction)
	animation_state.travel("walk")
	is_moving = true
	
func get_weapon_position(): 
	return 	global_position + weapon_position.position
