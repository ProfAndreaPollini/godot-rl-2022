extends "res://lib/ecs/Entity.gd"

var velocity = 200
var direction = Vector2.ZERO

func _ready():
	$Body/Smoke.emitting  =true

func _physics_process(delta):
	translate(velocity*direction*delta)
