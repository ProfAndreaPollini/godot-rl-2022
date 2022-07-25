tool

extends TileMap

const GRASS_TILES = [0, 0, 0, 0, 1, 2, 3, 4, 5]
const WATER_TILES = {
	top_left = 14,
	top = 15,
	top_right = 16,
	middle_left = 17,
	middle = 18,
	middle_right = 19,
	bottom_left = 20,
	bottom = 21,
	bottom_right = 22,
	corner_bottom_left = 23,
	corner_bottom_right = 24,
	corner_top_left = 25,
	corner_top_right = 26,
	corner_top_right_bottom_left = 27,
	corner_top_left_bottom_right = 28,
}
const HILL_TILES = {
	top_left = 29,
	top = 30,
	top_right = 31,
	middle_left = 32,
	middle = 37,
	middle_right = 33,
	bottom_left = 34,
	bottom = 35,
	bottom_right = 36,
	corner_bottom_left = 38,
	corner_bottom_right = 39,
	corner_top_left = 40,
	corner_top_right = 41
}

# We want our base tilemap to be bigger then our draw view,
# so we can calculate lakes and other stuff that go outside our view.
const TILE_MAP_EXTRA_SIZE = 100
const RIVER_ASTAR_WEIGHT_MULTIPLIER = 10000

enum Tiles { Grass, Water, Hill }

export (bool) var redraw = false setget _redraw
export (bool) var clear = false setget _clear
export (int) var width = 256
export (int) var height = 256

export (bool) var generate_rivers = false

export (int) var terrain_seed = 1101
export (int) var terrain_octaves = 7
export (float) var terrain_period = 150.0
export (float) var terrain_lacunarity = 1.5
export (float) var terrain_persistence = 1.0
export (float) var terrain_water_level = -0.1
export (float) var terrain_hills_level = 0.1

export (int) var grass_seed = 28
export (int) var grass_octaves = 5
export (float) var grass_period = 50.0
export (float) var grass_lacunarity = 0.7
export (float) var grass_persistence = 0.0

var _perf_logger = preload("../utils/PerfLogger.gd")

var _terrain_noise: OpenSimplexNoise = OpenSimplexNoise.new()
var _grass_noise: OpenSimplexNoise = OpenSimplexNoise.new()

var _tile_map: Array = []
var _tile_map_width: int = 0
var _tile_map_height: int = 0
var _tile_map_x_offset: int = 0
var _tile_map_y_offset: int = 0

var _lakes: Array = []
var _lakes_borders: Array = []
	
func _redraw(value: bool):
	if not value and Engine.is_editor_hint():
		return
		
	print("[Terrain] Redraw terrain")
	_generate_world()


func _clear(value: bool):
	if not value and Engine.is_editor_hint():
		return

	print("[Terrain] Clear terrain")
	clear()

func _generate_world():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Generate world")

	_terrain_noise.seed = terrain_seed
	_terrain_noise.octaves = terrain_octaves
	_terrain_noise.period = terrain_period
	_terrain_noise.lacunarity = terrain_lacunarity
	_terrain_noise.persistence = terrain_persistence

	_grass_noise.seed = grass_seed
	_grass_noise.octaves = grass_octaves
	_grass_noise.period = grass_period
	_grass_noise.lacunarity = grass_lacunarity
	_grass_noise.persistence = grass_persistence
	
	clear()

	_build_tile_map()
	_update_tiles()

	update_bitmask_region()
	
	perf_logger.stop()

func _build_tile_map():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Build tile map")
	
	_tile_map = []
	_tile_map_width = width + TILE_MAP_EXTRA_SIZE
	_tile_map_height = height + TILE_MAP_EXTRA_SIZE
	_tile_map_x_offset = _tile_map_width / 2
	_tile_map_y_offset = _tile_map_height / 2

	for y in range(-_tile_map_height / 2, (_tile_map_height / 2)):
		var tile_map_row = []
		for x in range(-_tile_map_width / 2, (_tile_map_width / 2)):
			var noise_sample = _terrain_noise.get_noise_2d(float(x), float(y))
			if noise_sample < terrain_water_level:
				tile_map_row.append(Tiles.Water)
			elif noise_sample > terrain_hills_level:
				tile_map_row.append(Tiles.Hill)
			else:
				tile_map_row.append(Tiles.Grass)
				
		_tile_map.append(tile_map_row)
		
	_cleanup_single_tiles()
	_detect_lakes()
	_detect_lakes_borders()
	
	if generate_rivers:
		_generate_rivers()
		
	perf_logger.stop()

# We need to cleanup singles tiles because, for satisfy our tilesheet, we need
# that every tile is near another tile. This is valid both horizontally and vertically.
func _cleanup_single_tiles():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Cleanup single tiles")
	
	var need_a_check = true
	while need_a_check:
		need_a_check = false
		for y in range(1, _tile_map_height - 1):
			for x in range(1, _tile_map_width - 1):
				# grass is our default tile and is always valid
				if _tile_map[y][x] == Tiles.Grass:
					continue
					
				if (_tile_map[y][x - 1] != _tile_map[y][x] and _tile_map[y][x + 1] != _tile_map[y][x]) or \
					(_tile_map[y - 1][x] != _tile_map[y][x] and _tile_map[y + 1][x] != _tile_map[y][x]):
					_tile_map[y][x] = Tiles.Grass
					need_a_check = true
	
	perf_logger.stop()
	
func _detect_lakes():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Detect lakes")
	
	var bfs = preload("../utils/BreadthFirstSearch.gd").new()
	bfs.set_size(_tile_map_width, _tile_map_height)
	
	_lakes = []
	for y in range(_tile_map_height):
		for x in range(_tile_map_width):
			if _tile_map[y][x] == Tiles.Water and not bfs.is_processed(x, y):
				_lakes.append(bfs.search(_tile_map, x, y))
		
	perf_logger.stop()
	
func _detect_lakes_borders():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Detect lakes borders")

	var move_positions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

	for lake in _lakes:
		var lake_border = []
		for point in lake:
			for move_position in move_positions:
				var x = point.x + move_position[0]
				var y = point.y + move_position[1]
				if x < 0 or y < 0 or x >= _tile_map_width or y >= _tile_map_height:
					continue
					
				if _tile_map[y][x] == Tiles.Grass:
					lake_border.append(point)
					break
		_lakes_borders.append(lake_border)
		
	perf_logger.stop()
	
func _detect_lakes_best_connection_points(lake_a: Array, lake_b: Array):
	var cardinal_points_a = _detect_lake_cardinal_points(lake_a)
	var cardinal_points_b = _detect_lake_cardinal_points(lake_b)
	
	var best_point_a = cardinal_points_a[0]
	var best_point_b = cardinal_points_b[0]
	var best_distance = best_point_a.distance_to(best_point_b)
	
	for point_a in cardinal_points_a:
		for point_b in cardinal_points_b:
			var distance = point_a.distance_to(point_b)
			if distance < best_distance:
				best_distance = distance
				best_point_a = point_a
				best_point_b = point_b

	return {
		"point_a": best_point_a,
		"point_b": best_point_b,
		"distance": best_distance
	}

func _detect_lake_cardinal_points(lake: Array):
	if lake.size() == 0:
		return []
		
	var most_left_point = lake[0]
	var most_right_point = lake[0]
	var most_top_point = lake[0]
	var most_bottom_point = lake[0]
	
	for point in lake:
		if point.x < most_left_point.x:
			most_left_point = point
		if point.x > most_right_point.x:
			most_right_point = point
		if point.y < most_top_point.y:
			most_top_point = point
		if point.y > most_bottom_point.y:
			most_bottom_point = point
			
	return [ most_left_point, most_top_point, most_right_point, most_bottom_point ]

func _prepare_rivers_astar():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Prepare rivers astar")

	var astar = AStar2D.new()
	
	var move_positions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
	for y in range(_tile_map_height):
		for x in range(_tile_map_width):
			if _tile_map[y][x] == Tiles.Grass:
				var id = _calculate_astar_id(x, y)
				if not astar.has_point(id):
					astar.add_point(id, Vector2(float(x), float(y)), _calculate_astar_weight(x, y))
				for move_position in move_positions:
					var other_x = x + move_position[0]
					var other_y = y + move_position[1]
					if other_x < 0 or other_y < 0 or other_x >= _tile_map_width or other_y >= _tile_map_width:
						continue
						
					var other_id = _calculate_astar_id(other_x, other_y)
					if _tile_map[other_y][other_x] == Tiles.Grass:
						if not astar.has_point(other_id):
							astar.add_point(other_id, Vector2(float(other_x), float(other_y)),
								_calculate_astar_weight(other_x, other_y))
						astar.connect_points(id, other_id, true)
						
	perf_logger.stop()
	return astar
	
func _get_nearest_grass(point: Vector2):
	var move_positions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
	for move_position in move_positions:
		var other_x = point.x + move_position[0]
		var other_y = point.y + move_position[1]
		if other_x < 0 or other_y < 0 or other_x >= _tile_map_width or other_y >= _tile_map_width:
			continue
		if _tile_map[other_y][other_x] == Tiles.Grass:
			return Vector2(other_x, other_y)
			
	return null

func _generate_rivers():
	if _lakes.size() == 0:
		return

	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Generate rivers")
	
	var astar = _prepare_rivers_astar()
		
	for lake_a in _lakes:
		var current_best_points = null
		for lake_b in _lakes:
			if lake_a == lake_b:
				break
				
			var best_points = _detect_lakes_best_connection_points(lake_a, lake_b)
			if current_best_points == null or best_points["distance"] < current_best_points["distance"]:
				current_best_points = best_points
		
		if current_best_points != null:
			var point_a = _get_nearest_grass(current_best_points["point_a"])
			var point_b = _get_nearest_grass(current_best_points["point_b"])
			if point_a != null and point_b != null:
				_generate_river(astar, point_a, point_b)
		
	perf_logger.stop()

func _generate_river(astar: AStar2D, source: Vector2, destination: Vector2):
	var source_id = _calculate_astar_id(int(source.x), int(source.y))
	var destination_id = _calculate_astar_id(int(destination.x), int(destination.y))
	var points = astar.get_point_path(source_id, destination_id)
	print("[Terrain] River points: {0}".format({0:points.size()}))
	for point in points:
		_tile_map[int(point.y)][int(point.x)] = Tiles.Water
	
func _calculate_astar_id(x: int, y: int):
	return (y * _tile_map_width) + x + 1
	
func _calculate_astar_weight(x: int, y: int):
	return ((_terrain_noise.get_noise_2d(float(x), float(y)) * -1) + 1.0) * RIVER_ASTAR_WEIGHT_MULTIPLIER
	
#func _sort_points_by_distance(points: Array):
#	if points.size() == 0:
#		return points
#		
#	var result = []	
#	
#	# our first point is the start reference point
#	var current_point = points.pop_front()
#	result.append(current_point)
#	
#	while points.size() > 0:
#		var best_match_position = -1
#		var best_match_distance = 0.0
#		for position in range(points.size()):
#			if best_match_position == --1 or current_point.distance_to(points[position]) < best_match_distance:
#				best_match_position = position
#				best_match_distance = current_point.distance_to(points[position])
#		result.append(points.pop_at(best_match_position))
#	
#	return result

#func _find_deeper_point_for_lake(lake: Array):
#	var deeper_point = lake[0]
#	var last_value = _terrain_noise.get_noise_2d(float(deeper_point[0]), float(deeper_point[1]))
#	for index in range(1, lake.size()):
#		var current_value = _terrain_noise.get_noise_2d(float(lake[index][0]), float(lake[index][1]))
#		if current_value < last_value:
#			last_value = current_value
#			deeper_point = lake[index]
#			
#	return deeper_point

func _update_tiles():
	var perf_logger = _perf_logger.new()
	perf_logger.start("[Terrain] Update tiles")

	for y in range(-height / 2, height / 2):
		for x in range(-width / 2, width / 2):
			var tile_type = _get_tile_type(x, y)
			if tile_type == Tiles.Water:
				_set_water_tile(x, y)
			elif tile_type == Tiles.Hill:
				_set_hill_tile(x, y)
			elif tile_type == Tiles.Grass:
				_set_grass_tile(x, y)
				
	perf_logger.stop()

func _get_tile_type(x: int, y: int):
	return _tile_map[y + _tile_map_y_offset][x + _tile_map_x_offset]

func _set_water_tile(x: int, y: int):
	var top_tile = _get_tile_type(x, y - 1)
	var top_left_tile = _get_tile_type(x - 1, y - 1)
	var top_right_tile = _get_tile_type(x + 1, y - 1)
	var left_tile = _get_tile_type(x - 1, y)
	var right_tile = _get_tile_type(x + 1, y)
	var bottom_tile = _get_tile_type(x, y + 1)
	var bottom_left_tile = _get_tile_type(x - 1, y + 1)
	var bottom_right_tile = _get_tile_type(x + 1, y + 1)

	if top_tile == Tiles.Grass and left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.top_left)
	elif top_tile == Tiles.Grass and right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.top_right)
	elif bottom_tile == Tiles.Grass and left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.bottom_left)
	elif bottom_tile == Tiles.Grass and right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.bottom_right)

	elif top_tile == Tiles.Water and left_tile == Tiles.Water and top_left_tile == Tiles.Grass and bottom_tile == Tiles.Water and right_tile == Tiles.Water and bottom_right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_top_left_bottom_right)
	elif top_tile == Tiles.Water and right_tile == Tiles.Water and top_right_tile == Tiles.Grass and bottom_tile == Tiles.Water and left_tile == Tiles.Water and bottom_left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_top_right_bottom_left)
		
	elif top_tile == Tiles.Water and left_tile == Tiles.Water and top_left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_top_left)
	elif top_tile == Tiles.Water and right_tile == Tiles.Water and top_right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_top_right)
	elif bottom_tile == Tiles.Water and left_tile == Tiles.Water and bottom_left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_bottom_left)
	elif bottom_tile == Tiles.Water and right_tile == Tiles.Water and bottom_right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.corner_bottom_right)
		
	elif top_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.top)
	elif left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.middle_left)
	elif right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.middle_right)
	elif bottom_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), WATER_TILES.bottom)
	else:
		set_cellv(Vector2(x, y), WATER_TILES.middle)

func _set_hill_tile(x: int, y: int):
	var top_tile = _get_tile_type(x, y - 1)
	var top_left_tile = _get_tile_type(x - 1, y - 1)
	var top_right_tile = _get_tile_type(x + 1, y - 1)
	var left_tile = _get_tile_type(x - 1, y)
	var right_tile = _get_tile_type(x + 1, y)
	var bottom_tile = _get_tile_type(x, y + 1)
	var bottom_left_tile = _get_tile_type(x - 1, y + 1)
	var bottom_right_tile = _get_tile_type(x + 1, y + 1)

	if left_tile == Tiles.Grass and bottom_tile == Tiles.Hill and top_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.top_left)
	elif right_tile == Tiles.Grass and bottom_tile == Tiles.Hill and top_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.top_right)
		
	elif left_tile == Tiles.Grass and bottom_tile == Tiles.Hill:
		set_cellv(Vector2(x, y), HILL_TILES.middle_left)
	elif right_tile == Tiles.Grass and bottom_tile == Tiles.Hill:
		set_cellv(Vector2(x, y), HILL_TILES.middle_right)
	elif left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.bottom_left)
	elif right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.bottom_right)

	elif top_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.top)
	elif bottom_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.bottom)
		
	elif left_tile == Tiles.Hill and bottom_tile == Tiles.Hill and bottom_left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.corner_bottom_left)
	elif right_tile == Tiles.Hill and bottom_tile == Tiles.Hill and bottom_right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.corner_bottom_right)
	elif left_tile == Tiles.Hill and top_tile == Tiles.Hill and top_left_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.corner_top_left)
	elif right_tile == Tiles.Hill and top_tile == Tiles.Hill and top_right_tile == Tiles.Grass:
		set_cellv(Vector2(x, y), HILL_TILES.corner_top_right)
	else:
		set_cellv(Vector2(x, y), HILL_TILES.middle)
			
func _set_grass_tile(x: int, y: int):
	set_cellv(Vector2(x, y), _get_grass_tile_index(_grass_noise.get_noise_2d(float(x), float(y))))

func _get_grass_tile_index(noise_sample: float):
	var noise = (clamp(noise_sample, -1.0, 1.0) + 1) / 2
	if noise < 0 or noise > 1.0:
		noise = 0
		
	var index = int(round(noise * (GRASS_TILES.size() - 1)))
	return GRASS_TILES[index]
