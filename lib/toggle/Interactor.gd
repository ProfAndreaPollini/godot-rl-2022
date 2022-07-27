extends Node

signal interaction_request()

export(NodePath) var notification_node_path
onready var notification_node = get_node(notification_node_path)

var enabled := false setget _set_enabled


	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		emit_signal("interaction_request")
		


func _set_enabled(_enabled):
	enabled = _enabled
	set_process_input(_enabled)
	set_process_unhandled_key_input(_enabled)
	
