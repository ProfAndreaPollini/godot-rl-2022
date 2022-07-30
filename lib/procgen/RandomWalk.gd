extends Node
class_name RandomWalk

var iterations := 0

var direction := Vector2.UP

var DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

var points = []
var bounds: Rect2
var max_segment_length: int
var segment_length = 0

func _init(_max_segment_length,_iterations):
	iterations = _iterations
	max_segment_length = _max_segment_length


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func walk(start_point:Vector2, _bounds: Rect2):
	bounds = _bounds
	points.append(start_point)
	change_direction() # set initial direction

	for i in range(0, iterations):
	
		if randf() < 0.1 or segment_length > max_segment_length:
			if change_direction():
				segment_length = 0
			else:
				return points
			
		else:
			var new_point = move()
			if bounds.has_point(new_point) :
				points.append(new_point)
				segment_length += 1
			else:
				return points
	return points


func change_direction(): 
	#while direction == DIRECTIONS[0]:
	var directions = DIRECTIONS.duplicate()
	
	directions.shuffle()
	while len(directions) >0:
		direction = directions.pop_front()
		if  bounds.has_point(move()) :
			return true
		
	return false



func move():
	return  direction + points[-1]
	
