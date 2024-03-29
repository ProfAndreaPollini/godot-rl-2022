extends KinematicBody2D

var Bow = preload("res://lib/bow/Bow.tscn")

onready var movement = $KinematicMovementComponent
onready var inventory = $Inventory
onready var weapon_position = $WeaponPosition

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

onready var weapon = inventory.get_child(0)

var is_moving := false
var weapon_position_distance :=0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	movement.connect("moved",self,"on_moved")
	movement.connect("stopped",self,"on_stopped")
	EventBus.connect("player_on_weapon",self, "on_player_on_weapon")
	EventBus.connect("player_exchange_weapon",self,"on_player_exchange_weapon")
	animation_state.travel("idle")
	weapon_position_distance = global_position.distance_to(weapon_position.position)

func on_player_exchange_weapon(new_weapon: Node2D):
	print("on_player_exchange_weapon()")
	
	for item in inventory.get_children():
		item.visible = false
	
	new_weapon.visible = true
	inventory.move_child(new_weapon,0)
	weapon = inventory.get_child(0)
	EventBus.emit_signal("weapon_modifed")
	

func on_player_on_weapon(_weapon):
	print("on_player_on_weapon")
	add_weapon_to_inventory(_weapon)
	
func add_weapon_to_inventory(_weapon):
	if inventory.has_free_slot():
		_weapon.get_parent().remove_child(_weapon)
		_weapon.visible = false
		_weapon.entity = get_path()
		_weapon.disable_player_on_weapon()
		inventory.add_item(_weapon)

func _physics_process(delta):
	movement.update(delta)
	#if is_moving:
	var mouse_position = get_global_mouse_position()
	movement.direction = lerp(movement.direction,(mouse_position - global_position).normalized(),0.9)
	
	if weapon:
		weapon_position.look_at(mouse_position)
		weapon.on_mouse_moved(get_weapon_position(),movement.direction)
	# var mouse_position = get_global_mouse_position()
	
	# movement.direction = (mouse_position - get_weapon_position()).normalized()
	
	# weapon_position.look_at(mouse_position)
	var animation_param = movement.direction #Vector2(stepify(movement.direction.x,0.1),stepify(movement.direction.y,0.1)) 
	#print("weapon = ",weapon_position.position, get_weapon_position(),weapon_position.global_position)


	animation_tree.set("parameters/idle/blend_position", animation_param)
	animation_tree.set("parameters/walk/blend_position", animation_param)
	
	if Input.is_action_just_pressed("fire") and weapon:
		weapon.shoot()
	
	
	update()
	
func _input(event):
	if event is InputEventMouseMotion:
		is_moving = true
		
#	if event is InputEventKey:
#		if event.scancode == KEY_SPACE:
#			weapon.shoot()
		

	
func _draw():
	draw_circle(to_local(get_weapon_position()),2,Color(1,1,0))
#	if is_moving:
#		draw_circle(Vector2(10,10),2,Color.green)
	
func on_stopped():
	animation_state.travel("idle")
	is_moving = false

func on_moved():
	#print("moved: ",movement.direction)
	animation_state.travel("walk")
	is_moving = true
	
func get_weapon_position(): 
	return 	global_position + weapon_position.position
