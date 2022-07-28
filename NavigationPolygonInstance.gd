extends NavigationPolygonInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = NavigationPolygon.new()
	p.add_outline($Polygon2D.polygon)
	p.make_polygons_from_outlines()
	
	navpoly = p
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
