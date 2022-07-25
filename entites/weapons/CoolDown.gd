extends Node
class_name CoolDown

var is_firing := false
var COOLDOWN_TIME := 1
var fire_time := 0.0

func reset_fire_time():
	fire_time = 0.0

func increment_fire_time(delta):
	fire_time += delta

func start():
  is_firing = true
  reset_fire_time()

func can_fire():
	return not is_firing or fire_time >= COOLDOWN_TIME

func is_cooldown_ended():
	if fire_time >= COOLDOWN_TIME:
		is_firing = false
		reset_fire_time()
		return true
	else:
		return false
		

	

# func _process(delta):
#   if  is_firing:
# 	  fire_time += delta
#   elif fire_time > COOLDOWN_TIME:
# 	  is_firing = false
# 	  reset_fire_time()
	
