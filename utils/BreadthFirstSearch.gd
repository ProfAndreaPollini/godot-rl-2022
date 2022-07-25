extends Object

# Breadth-first search: https://en.wikipedia.org/wiki/Breadth-first_search
# Adapted to work with a matrix. It automatically detect the graph exploring
# nearest cells and keeping track of processed cells

# Valid movement position for calculate the graph
var _move_positions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

var _width = 0
var _height = 0
var _processed = []

func set_size(width, height):
	_width = width
	_height = height
	_processed = []
	for y in range(height):
		var processed_row = []
		for x in range(width):
			processed_row.append(false)
		_processed.append(processed_row)

func is_processed(x, y):
	return _processed[y][x]

func search(matrix, x, y):
	var queue = []
	var result = []
	
	queue.append([x, y])
	result.append(Vector2(float(x), float(y)))

	_processed[y][x] = true
	var ref_value = matrix[y][x]
	
	while queue.size() > 0:
		var pair = queue.pop_front()
		for move_pos in _move_positions:
			var pos_x = pair[0] + move_pos[0]
			var pos_y = pair[1] + move_pos[1]
			if _is_safe(matrix, pos_x, pos_y, ref_value):
				_processed[pos_y][pos_x] = true
				queue.append([pos_x, pos_y])
				result.append(Vector2(float(pos_x), float(pos_y)))
	return result

func _is_safe(matrix, x, y, ref_value):
	return x >= 0 and x < _width and y >= 0 and y < _height and matrix[y][x] == ref_value and not _processed[y][x]
	
