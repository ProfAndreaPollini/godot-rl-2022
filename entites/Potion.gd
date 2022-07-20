extends Area2D

var entity
var owner_entity = null

onready var inventory_icon = get_node("Sprite")

var icon: Texture = preload("res://assets/0x72_DungeonTilesetII_v1.4/0x72_DungeonTilesetII_v1.4/frames/flask_big_yellow.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_close_to(_entity):
	$Label.visible = true
	entity = _entity
	
func is_not_close_to(_entity):
	$Label.visible = false
	entity = _entity
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F and entity:
			get_parent().remove_child(self)
			entity.pickup(self)
			entity = null
			
		
