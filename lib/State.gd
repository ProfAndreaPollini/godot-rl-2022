extends Node
class_name State

export onready  var state_name := name.to_lower()

onready var state_machine :StateManager = get_parent()


func _ready():
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	set_physics_process(false)


func switch_to(new_state_name):
	state_machine.switch_to_state(new_state_name)

func _enter_state():
	print("entering state")
	
	
func _exit_state():
	pass

func _physics_process(delta):
	pass
	
func _input(event):
	pass
