extends StaticBody2D


export(Vector2) var closed_door_region_position
export(Vector2) var opened_door_region_position

export(Dictionary) var context = {}

onready var conditions = $Conditions.get_children()

var is_opened := false setget set_opened

func _ready():
	for condition in conditions:
		condition.setup(context)
	set_opened(false)
	

func check_conditions():

	for condition in conditions:
		if not condition.check():
			print("no")
			return false
	return true

func set_opened(opened):
	
	if opened:
		opened = check_conditions()
	
	if opened:
		
		$Sprite.region_rect.position = opened_door_region_position
		#$SenseArea.set_collision_mask_bit(0,false)
		set_collision_mask_bit(0,false)
		
	else:
		$Sprite.region_rect.position = closed_door_region_position
		#$SenseArea.set_collision_mask_bit(0,true)
		set_collision_mask_bit(0,true)
	is_opened = opened

func _on_SenseArea_mouse_entered():
	set_opened(true)


func _on_SenseArea_mouse_exited():
	set_opened(false)
