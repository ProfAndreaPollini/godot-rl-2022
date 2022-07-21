extends CanvasLayer

var sentences = []
var current = 0

func say(text):
	sentences = text
	current = 0
	$MarginContainer/HBoxContainer/Label.text = sentences[0]
	$MarginContainer/HBoxContainer/VBoxContainer/Label.text = str(current+1) + "/"  + str(len(sentences))
	$AnimationPlayer.play("show")
	
func next_page():
	current += 1
	if current >= len(sentences):
		return false
	else: 
		$MarginContainer/HBoxContainer/Label.text = sentences[current]
		$MarginContainer/HBoxContainer/VBoxContainer/Label.text = str(current+1) + "/"  + str(len(sentences))
		return true
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var ok = next_page()
		if not ok:
			hide()
	
	
func hide():
	$AnimationPlayer.play("hide")
