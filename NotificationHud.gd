extends Node2D


onready var tween  = $Tween

func set_text(txt):
	$Label.text = txt
	
func _ready():
	tween.interpolate_property(self, "position", position, position + Vector2(0,-20), 1.0)
	$AnimationPlayer.play("idle")
	tween.start()
	

	


func _on_NotificationHud_child_entered_tree(node):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "idle":
		queue_free()
