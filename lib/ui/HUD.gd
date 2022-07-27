extends CanvasLayer


onready var num_items = $"%MenuItems"
onready var inventory_ui = $InventoryContainer
onready var inventory_items_ui = $"%GridContainer"
export(NodePath) var player_path 

onready var player = get_node(player_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("inventory_modified",self, "on_inventory_modified")
	EventBus.connect("weapon_modifed",self,"on_weapon_modified")
	inventory_ui.visible = false
	
func _update_invetory_ui():
	for el in inventory_items_ui.get_children():
		el.texture = null
		el.item = null
		
		
	print(" ui invntory slots: ",inventory_items_ui.get_child_count())
	var pos = 0
	for inventory_item in player.inventory.get_children():
		#inventory_ui.show_item(inventory_item)	
		#var path = "InventoryItemIcon{0}".format({0:pos})
		var node = inventory_items_ui.get_child(pos)
		print(" -> ",node)
		node.texture = inventory_item.icon_texture
		node.item = inventory_item
		

func on_weapon_modified():
	_update_invetory_ui()
	
func on_inventory_modified(inventory):
	print("inventory modified")
	num_items.text = str(inventory.get_child_count())
	
	_update_invetory_ui()


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
	

func _on_Button_button_down():
	inventory_ui.visible = false
	enable_player_input(true)
