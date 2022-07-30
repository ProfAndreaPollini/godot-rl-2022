extends KinematicBody2D

signal hit()

var target : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent2D.set_target_location(global_position)
	connect("hit",self,"on_hit")

#func _physics_process(delta):
	
func on_hit():
	$AnimationPlayer.play("hit")
	$CPUParticles2D.emitting = true
	
func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		print("new path")
		target = get_global_mouse_position()
		$NavigationAgent2D.set_target_location(target)
		#print($NavigationAgent2D.get_nav_path())
		$AnimationPlayer.play("hit")
		
		
		
		
func _physics_process(delta):
	if target:
		var next_position  =$NavigationAgent2D.get_next_location()
		#print(next_position,global_position)
		var v = global_position.direction_to(next_position) * 40
		$NavigationAgent2D.set_velocity(v)
		if $NavigationAgent2D.is_navigation_finished():
			print("nav finished")
			
		if $NavigationAgent2D.is_target_reached():
			print("target_reached")

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_slide(safe_velocity)
