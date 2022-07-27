extends Node2D

var is_toggled := false setget _toggle

onready var sense_area = $SenseArea
onready var interactor = $Interactor

# Called when the node enters the scene tree for the first time.
func _ready():
	$Interactor.connect("interaction_request",self,"on_interaction_request")
	$InteractorUIMessage.visible = false
	$Sprite.frame = 1
	is_toggled = false


func on_interaction_request():
	print("interaction")
	toggle()
	
func toggle() -> bool:
	$Sprite.frame = ($Sprite.frame +1) % 2
	is_toggled = not is_toggled
	return is_toggled

func _toggle(status):
	
	is_toggled = status

func _on_SenseArea_body_entered(body):
	print("close to toggle")
	interactor.enabled = true
	$InteractorUIMessage.visible = true
	


func _on_SenseArea_body_exited(body):
	interactor.enabled = false
	$InteractorUIMessage.visible = false
