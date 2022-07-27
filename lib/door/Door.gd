extends Node2D


export(Vector2) var closed_door_region_position
export(Vector2) var opened_door_region_position

var is_opened := false setget set_opened

func _ready():
	set_opened(false)


func set_opened(opened):
	if opened:
		$Sprite.region_rect.position = opened_door_region_position
		#$SenseArea.set_collision_mask_bit(0,false)
	else:
		$Sprite.region_rect.position = closed_door_region_position
		#$SenseArea.set_collision_mask_bit(0,true)


func _on_SenseArea_mouse_entered():
	set_opened(true)


func _on_SenseArea_mouse_exited():
	set_opened(false)
