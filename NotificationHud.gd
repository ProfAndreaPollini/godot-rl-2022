extends Node2D


onready var tween  = $Tween

func set_text(txt):
	$Label.text = txt
	
func _ready():
	tween.interpolate_property(self, "position", position, position + Vector2(0,-200), 1.0)
	#$AnimationPlayer.play("idle")
