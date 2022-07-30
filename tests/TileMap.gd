tool
extends TileMap

var RandomWalk = preload("res://lib/procgen/RandomWalk.gd")


export(Vector2) var map_size = Vector2(10,10)
export(bool) var generate setget set_generate
export(int,1,100) var max_segment_length = 1
export(int,1,1000) var max_points = 100
export(int,1,4) var tile_scale = 1
export(int,1,500) var num_walkers = 10

var tiles = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_generate(_value):
	print("generate")
	randomize()
	tiles["floor"]  = tile_set.find_tile_by_name("floor")
	tiles["wall"] = tile_set.find_tile_by_name("wall")
	
	var map_rect = Rect2(Vector2(-map_size.x/2,-map_size.y/2),map_size)
	
	for i in range(-map_size.x/2, map_size.x/2):
		for j in range(-map_size.y/2, map_size.y/2):
			set_cell(i,j,tiles["wall"])
	
	var generated_points =[]

	for _i in range(num_walkers):
		var start_point = Vector2.ZERO
		var walker = RandomWalk.new(max_segment_length,max_points)
		var new_points = walker.walk(start_point,map_rect)
		
		for p in new_points:
			if not generated_points.has(p):
				generated_points.append(p)

			
		generated_points.shuffle()
		start_point = generated_points[0]
	
	#aggiorno tilemap
	for p in generated_points:
		print(".")
		for x in range(0,tile_scale):
			for y in range(0,tile_scale):
				var cell = p + Vector2(x,y)
				print(cell)
				if map_rect.has_point(cell):
					set_cellv(cell,tiles["floor"])
