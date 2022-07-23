extends KinematicBody2D


signal moved(dx,dy)

onready var inventory = $Inventory
onready var pocket = $Pocket

onready var weapon_position = $sword_position
onready var weapon = get_node("Weapon").get_child(0)

export  var offset: Vector2 = Vector2.ZERO

onready var entity_pivot: Vector2 = Vector2.ZERO setget ,get_entity_pivot
var direction := Vector2.ZERO 

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("moved",self,"on_moved")
	
func on_moved(dx: float ,dy : float ) -> void:
	pass
	#print("on_moved",weapon)
#	if weapon:
#
#		weapon.global_position = get_entity_pivot()
	
func _physics_process(delta):
	$AnimatedSprite.flip_h = (get_global_mouse_position() - global_position).dot(Vector2.RIGHT) < 0
	if weapon:
		direction = (get_global_mouse_position() - get_entity_pivot()).normalized()
		#weapon.on_mouse_moved(get_entity_pivot(),direction)

		weapon.global_position = global_position + 10*direction
		weapon.global_position.x = clamp(weapon.global_position.x,global_position.x-5,global_position.x+5)
		weapon.global_position.y = clamp(weapon.global_position.y,global_position.y-20,global_position.y)
		
		weapon.look_at(global_position + 200*direction)
		
		weapon.rotate(deg2rad(90))
	
func can_equip(obj)-> bool:
	return obj.get_groups().has("weapon") and $Weapon.get_child_count() == 0
	
func pick_coin(coin):
	print("pick {0}".format({0:coin}))
	EventBus.emit_signal("pick_coin",coin)
	inventory.add_coin(coin)
	
	
func add_weapon(new_weapon) -> void:
	$Weapon.add_child(new_weapon) 
	new_weapon.owner_entity = self
	new_weapon.position = Vector2.ZERO
	new_weapon.global_position = weapon_position.global_position
	weapon = new_weapon
	
	#weapon.global_position = get_entity_pivot() 
	print(weapon.owner_entity)
	
func get_entity_pivot(): 
	return 	global_position + offset

func pickup(item):
	print("picked up item = ",item)
	if inventory.has_free_slot():
		item.owner_entity = self
		pocket.add_item(item)
		item.visible = false
	

func _input(event):
	if (event is InputEventMouseMotion  or event is InputEventKey) and weapon:
		
#		direction = (get_global_mouse_position() - get_entity_pivot()).normalized()
#		#weapon.on_mouse_moved(get_entity_pivot(),direction)
#
#		weapon.global_position = global_position + 10*direction
#		weapon.global_position.x = clamp(weapon.global_position.x,global_position.x-5,global_position.x+5)
#		weapon.global_position.y = clamp(weapon.global_position.y,global_position.y-20,global_position.y)
#
#		weapon.look_at(global_position + 200*direction)
#
#		weapon.rotate(deg2rad(90))
		print(weapon.global_position)
		

