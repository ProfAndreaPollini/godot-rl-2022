extends CanvasLayer


onready var num_items = $"%MenuItems"
onready var inventory_ui = $InventoryContainer
export(NodePath) var player_path 


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("inventory_modified",self, "on_inventory_modified")
	inventory_ui.visible = false
	player = get_node(player_path)
	
func on_inventory_modified(inventory):
	print("inventory modified")
	num_items.text = str(inventory.get_child_count())
	
	for inventory_item in inventory.get_children():
		inventory_ui.show_item(inventory_item)


func _on_TextureRect_mouse_entered():
	inventory_ui.visible = true
	enable_player_input(false)
	
func enable_player_input(enable):
	player.set_process_input(enable)
	player.set_physics_process(enable)
	player.set_process(enable)
	player.set_process_unhandled_input(enable)


func _on_InventoryContainer_mouse_exited():
	inventory_ui.visible = false
	enable_player_input(true)
	



func _on_ColorRect_mouse_exited():
	inventory_ui.visible = false
	enable_player_input(true)
	

