extends CanvasLayer


var show_debug_interface  := false
onready var _ui_container = $DebugLayerContainer
onready var debug_messages = $DebugLayerContainer/VBoxContainer/DebugMessages



var DebugMessage = preload("res://utils/DebugMessage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_ui_container.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_debug_message(message):
	#if debug_messages.get_child_count() > 5:
	#	debug_messages.remove_child(debug_messages.get_child(get_child_count()-1))	
	
	var mes_ui = DebugMessage.instance()
	mes_ui.set_message(message)
	debug_messages.add_child(mes_ui)
	debug_messages.move_child(mes_ui, 0)


func _input(event):
	if Input.is_action_just_pressed("toggle_debug_ui") and show_debug_interface == false:
		#$Tween.interpolate_property(self,"_ui_container.position.y",_ui_container.position.y,0,1000,Tween.TRANS_CUBIC).start()
		
		show_debug_interface = true
		_ui_container.visible = show_debug_interface
	elif Input.is_action_just_pressed("toggle_debug_ui") and show_debug_interface == true:
		#$Tween.interpolate_property(self,"_ui_container.position.y",_ui_container.position.y,get_viewport().size.y + 10,1000,Tween.TRANS_CUBIC).start()
		show_debug_interface = false
		_ui_container.visible = show_debug_interface
		
	
		






func _on_Button_button_down():
	
	while debug_messages.get_child_count() >0:
		var msg = debug_messages.get_child(0)
		debug_messages.remove_child(msg)
