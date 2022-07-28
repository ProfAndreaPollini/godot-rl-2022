extends KinematicBody2D


var target : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent2D.set_target_location(global_position)


#func _physics_process(delta):
	
func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		print("new path")
		target = get_global_mouse_position()
		$NavigationAgent2D.set_target_location(target)
		print($NavigationAgent2D.get_nav_path())
		$Line2D.points = $NavigationAgent2D.get_nav_path()
		
		
func _physics_process(delta):
	if target:
		var next_position  =$NavigationAgent2D.get_next_location()
		#print(next_position,global_position)
		var v = global_position.direction_to(next_position) * 20
		$NavigationAgent2D.set_velocity(v)

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)
