extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var slots = [$slot0,$slot1]


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)
	EventBus.connect("open_inventory",self,"on_open_inventory")
	EventBus.connect("close_inventory",self,"on_close_inventory")
	EventBus.connect("inventory_modified",self, "on_inventory_modified")
	
func on_inventory_modified(inventory):
	print("UI: on_inventory_modified ({0})".format({0:inventory.get_child_count()}))
	var pos = 0
	for obj in inventory.get_children():
		slots[pos].texture = obj.icon_texture
		pos += 1


func on_open_inventory():
	set_process_input(true)
	visible = true
	
func on_close_inventory():
	set_process_input(false)
	visible = false


func _on_TextureButton_button_down():
	EventBus.emit_signal("close_inventory")
