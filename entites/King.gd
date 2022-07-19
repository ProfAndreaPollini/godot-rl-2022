extends KinematicBody2D


signal moved(dx,dy)

onready var weapon_position = $sword_position
onready var weapon = get_node("Weapon").get_child(0)

onready var entity_pivot: Vector2 = Vector2.ZERO setget ,get_entity_pivot
var direction := Vector2.ZERO 

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("moved",self,"on_moved")
	
func on_moved(dx: float ,dy : float ) -> void:
	if weapon:
		weapon.on_mouse_moved(get_entity_pivot(),get_viewport().get_mouse_position())
	
func _physics_process(delta):
	pass
	
func can_equip(obj)-> bool:
	return obj.get_groups().has("weapon") and $Weapon.get_child_count() == 0
	
func add_weapon(new_weapon) -> void:
	$Weapon.add_child(new_weapon) 
	new_weapon.owner_entity = self
	new_weapon.on_mouse_moved(get_entity_pivot(),get_viewport().get_mouse_position())
	weapon = new_weapon
	print(weapon.owner_entity)
	
func get_entity_pivot(): 
	return 	global_position + Vector2(0,-9)

func _input(event):
	if event is InputEventMouseMotion and weapon:
		weapon.on_mouse_moved(get_entity_pivot(),event.position)
	
	
	#if Input.is_action_just_pressed("ui_accept"):
		
#func _process(delta):
	#weapon.fire((get_global_mouse_position() - get_entity_pivot()).normalized())


