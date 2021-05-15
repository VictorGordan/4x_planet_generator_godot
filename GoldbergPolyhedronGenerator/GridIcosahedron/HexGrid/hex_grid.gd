extends Node

# (n - 1) is the smallest number of hexagons between two pentagons

func point_line(v1: Vector3, v2: Vector3, n: int) -> PoolVector3Array:
	# creates n + 1 points between v1 and v2 at equal distances
	var array: PoolVector3Array = []
	if n == 0:
		array.append(v1)
		return array
	var base_vec: Vector3 = (v2 - v1) / n
	for i in range(n + 1):
		array.append(v1 + i * base_vec)
	return array

func three_lines(v1: Vector3, tip: Vector3, v2: Vector3, n: int) -> PoolVector3Array:
	# creates first 3 lines of the hex grid (these then repeat with smaller n)
	# v1 tip v2 clockwise vertices of triangle
	var array: PoolVector3Array = []
	if n == 0:
		array.append(tip)
		return array
	var base_vec: Vector3 = (v2 - v1) / (2 * n)
	var plane_vec: Vector3 = ((tip - v1) - ((v2 - v1) / 2)) / (n * 3)
	for i in range(3):
		array = array + point_line(
			v1 + i * base_vec + i * plane_vec, 
			v2 - i * base_vec + i * plane_vec, 
			n - i)
	return array

func hex_grid(v1: Vector3, tip: Vector3, v2: Vector3, n: int) -> PoolVector3Array:
	# creates a hexagonal grid in the same of a triangle
	# triangles has vertices v1 tip v2
	var array: PoolVector3Array = []
	var base_vec: Vector3 = (v2 - v1) / (2 * n)
	var plane_vec: Vector3 = ((tip - v1) - ((v2 - v1) / 2)) / n
	for i in range(n + 1):
		array = array + three_lines(
			v1 + i * base_vec + i * plane_vec,
			tip,
			v2 - i * base_vec + i * plane_vec,
			n - i)
	return array

func order_hex (x: float, y: float, hex_grid: PoolVector3Array, n: float) -> PoolVector3Array:
	# creates an PoolVector3Array of one hexagon in the proper order
	# proper order is center first, then vertices in clockwise order
	var array: PoolVector3Array = [0, 1, 2, 3, 4, 5, 6]
	var center: float = 3 * y * (n - ((y - 1) / 2)) + x
	array[0] = hex_grid[center]
	array[1] = hex_grid[center + (n - y) * 2]
	array[2] = hex_grid[center + (n - y) + 1]
	array[3] = hex_grid[center - (n - y)]
	array[4] = hex_grid[center - (n - y) * 2 - 1]
	array[5] = hex_grid[center - (n - y) - 1]
	array[6] = hex_grid[center + (n - y)]
	return array

func order_inner_hex(hex_grid: PoolVector3Array, n: int) -> Array:
	# uses order_hex on all complete hexagons of hex_grid
	# complete hexagons do not include half hexagons (sides of triangle)
	var array: Array = []
	var row: int = 0
	for y in range(1, n - 1):
		for x in range(1, n - 1 - row):
			array += [order_hex(x, y, hex_grid, n)]
		row += 1
	return array
