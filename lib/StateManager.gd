extends Node
class_name StateManager

var states: Dictionary = {}

var current_state := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in range(get_child_count()):
		var state_name = get_child(c).state_name
		states[state_name] = get_child(c)
		if c == 0:
			switch_to_state(state_name)
		
		
	print("current_state is = ", current_state)
	
	
func switch_to_state(state_name):
	if states.has(state_name):
		if current_state != "":
			states[current_state]._exit_state()
		
		
		current_state = state_name
		states[current_state]._enter_state()
		print("new state is ", state_name)
	else:
		print("unknown  state ",state_name)
		

func _physics_process(delta):
	states[current_state]._physics_process(delta)

func _input(event):
	states[current_state]._input(event)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
 
