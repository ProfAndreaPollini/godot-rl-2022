tool

extends Node2D

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

enum TileType { Grass, Water, Hill }

export (bool) var enable_preview = false setget _set_enable_preview
export (int) var width = 256 setget _set_width
export (int) var height = 256 setget _set_height

export (int) var terrain_seed = 1101 setget _set_terrain_seed
export (int) var terrain_octaves = 7 setget _set_terrain_octaves
export (float) var terrain_period = 150.0 setget _set_terrain_period
export (float) var terrain_lacunarity = 1.5 setget _set_terrain_lacunarity
export (float) var terrain_persistence = 1.0 setget _set_terrain_persistence
export (float) var terrain_water_level = -0.1 setget _set_terrain_water_level
export (float) var terrain_hills_level = 0.1 setget _set_terrain_hills_level

export (int) var grass_seed = 28 setget _set_grass_seed
export (int) var grass_octaves = 5 setget _set_grass_octaves
export (float) var grass_period = 50.0 setget _set_grass_period
export (float) var grass_lacunarity = 0.7 setget _set_grass_lacunarity
export (float) var grass_persistence = 0.0 setget _set_grass_persistence

var terrain_noise = OpenSimplexNoise.new()
var grass_noise = OpenSimplexNoise.new()

func _ready():
	terrain_noise.seed = terrain_seed
	terrain_noise.octaves = terrain_octaves
	terrain_noise.period = terrain_period
	terrain_noise.lacunarity = terrain_lacunarity
	terrain_noise.persistence = terrain_persistence

	grass_noise.seed = grass_seed
	grass_noise.octaves = grass_octaves
	grass_noise.period = grass_period
	grass_noise.lacunarity = grass_lacunarity
	grass_noise.persistence = grass_persistence
	
	_generate_world()
	
func _generate_world():
	$TileMap.clear()
	
	if Engine.editor_hint and not enable_preview:
		return
		
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var tile_type = _get_tile_type(x, y)
			if tile_type == TileType.Water:
				_set_water_tile(x, y)
			elif tile_type == TileType.Hill:
				_set_hill_tile(x, y)
			elif tile_type == TileType.Grass:
				_set_grass_tile(x, y)
				
	$TileMap.update_bitmask_region()

func _get_tile_type(x, y):
	var noise_sample = terrain_noise.get_noise_2d(float(x), float(y))
	var noise_sample_top = terrain_noise.get_noise_2d(float(x), float(y - 1))
	var noise_sample_left = terrain_noise.get_noise_2d(float(x - 1), float(y))
	var noise_sample_right = terrain_noise.get_noise_2d(float(x + 1), float(y))
	var noise_sample_bottom = terrain_noise.get_noise_2d(float(x), float(y + 1))
	
	# we don't want water large only one tile
	if noise_sample < terrain_water_level and (
		noise_sample_top < terrain_water_level or noise_sample_bottom < terrain_water_level) and (
			noise_sample_left < terrain_water_level or noise_sample_right < terrain_water_level):
		return TileType.Water
		
	# same thing for the hills
	if noise_sample > terrain_hills_level and (
		noise_sample_top > terrain_hills_level or noise_sample_bottom > terrain_hills_level) and (
			noise_sample_left > terrain_hills_level or noise_sample_right > terrain_hills_level):
		return TileType.Hill
		
	return TileType.Grass

func _set_water_tile(x, y):
	var top_tile = _get_tile_type(x, y - 1)
	var top_left_tile = _get_tile_type(x - 1, y - 1)
	var top_right_tile = _get_tile_type(x + 1, y - 1)
	var left_tile = _get_tile_type(x - 1, y)
	var right_tile = _get_tile_type(x + 1, y)
	var bottom_tile = _get_tile_type(x, y + 1)
	var bottom_left_tile = _get_tile_type(x - 1, y + 1)
	var bottom_right_tile = _get_tile_type(x + 1, y + 1)

	if top_tile == TileType.Grass and left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.top_left)
	elif top_tile == TileType.Grass and right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.top_right)
	elif bottom_tile == TileType.Grass and left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.bottom_left)
	elif bottom_tile == TileType.Grass and right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.bottom_right)

	elif top_tile == TileType.Water and left_tile == TileType.Water and top_left_tile == TileType.Grass and bottom_tile == TileType.Water and right_tile == TileType.Water and bottom_right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_top_left_bottom_right)
	elif top_tile == TileType.Water and right_tile == TileType.Water and top_right_tile == TileType.Grass and bottom_tile == TileType.Water and left_tile == TileType.Water and bottom_left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_top_right_bottom_left)
		
	elif top_tile == TileType.Water and left_tile == TileType.Water and top_left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_top_left)
	elif top_tile == TileType.Water and right_tile == TileType.Water and top_right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_top_right)
	elif bottom_tile == TileType.Water and left_tile == TileType.Water and bottom_left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_bottom_left)
	elif bottom_tile == TileType.Water and right_tile == TileType.Water and bottom_right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.corner_bottom_right)
		
	elif top_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.top)
	elif left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.middle_left)
	elif right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.middle_right)
	elif bottom_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.bottom)
	else:
		$TileMap.set_cellv(Vector2(x, y), WATER_TILES.middle)

func _set_hill_tile(x, y):
	var top_tile = _get_tile_type(x, y - 1)
	var top_left_tile = _get_tile_type(x - 1, y - 1)
	var top_right_tile = _get_tile_type(x + 1, y - 1)
	var left_tile = _get_tile_type(x - 1, y)
	var right_tile = _get_tile_type(x + 1, y)
	var bottom_tile = _get_tile_type(x, y + 1)
	var bottom_left_tile = _get_tile_type(x - 1, y + 1)
	var bottom_right_tile = _get_tile_type(x + 1, y + 1)

	if left_tile == TileType.Grass and bottom_tile == TileType.Hill and top_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.top_left)
	elif right_tile == TileType.Grass and bottom_tile == TileType.Hill and top_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.top_right)
		
	elif left_tile == TileType.Grass and bottom_tile == TileType.Hill:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.middle_left)
	elif right_tile == TileType.Grass and bottom_tile == TileType.Hill:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.middle_right)
	elif left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.bottom_left)
	elif right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.bottom_right)

	elif top_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.top)
	elif bottom_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.bottom)
		
	elif left_tile == TileType.Hill and bottom_tile == TileType.Hill and bottom_left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.corner_bottom_left)
	elif right_tile == TileType.Hill and bottom_tile == TileType.Hill and bottom_right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.corner_bottom_right)
	elif left_tile == TileType.Hill and top_tile == TileType.Hill and top_left_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.corner_top_left)
	elif right_tile == TileType.Hill and top_tile == TileType.Hill and top_right_tile == TileType.Grass:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.corner_top_right)
	else:
		$TileMap.set_cellv(Vector2(x, y), HILL_TILES.middle)
			
func _set_grass_tile(x, y):
	$TileMap.set_cellv(Vector2(x, y), _get_grass_tile_index(grass_noise.get_noise_2d(float(x), float(y))))

func _get_grass_tile_index(noise_sample):
	var noise = (clamp(noise_sample, -1.0, 1.0) + 1) / 2
	if noise < 0 or noise > 1.0:
		noise = 0
		
	var index = int(round(noise * (GRASS_TILES.size() - 1)))
	return GRASS_TILES[index]

# PROPERTIES
	
func _set_enable_preview(value):
	enable_preview = value
	_generate_world()

func _set_width(value):
	width = value
	_generate_world()

func _set_height(value):
	height = value
	_generate_world()

func _set_terrain_seed(value):
	terrain_seed = value
	terrain_noise.seed = value
	_generate_world()

func _set_terrain_octaves(value):
	terrain_octaves = value
	terrain_noise.octaves = value
	_generate_world()

func _set_terrain_period(value):
	terrain_period = value
	terrain_noise.period = value
	_generate_world()

func _set_terrain_lacunarity(value):
	terrain_lacunarity = value
	terrain_noise.lacunarity = value
	_generate_world()

func _set_terrain_persistence(value):
	terrain_persistence = value
	terrain_noise.persistence = value
	_generate_world()

func _set_terrain_water_level(value):
	terrain_water_level = value
	_generate_world()

func _set_terrain_hills_level(value):
	terrain_hills_level = value
	_generate_world()
	
func _set_grass_seed(value):
	grass_seed = value
	grass_noise.seed = value
	_generate_world()

func _set_grass_octaves(value):
	grass_octaves = value
	grass_noise.octaves = value
	_generate_world()

func _set_grass_period(value):
	grass_period = value
	grass_noise.period = value
	_generate_world()

func _set_grass_lacunarity(value):
	grass_lacunarity = value
	grass_noise.lacunarity = value
	_generate_world()

func _set_grass_persistence(value):
	grass_persistence = value
	grass_noise.persistence = value
	_generate_world()
	
