extends Node

var icosahedron = load(self.get_script().get_path().get_base_dir() + "/Icosahedron/icosahedron.gd").new()
var hex = load(self.get_script().get_path().get_base_dir() + "/HexGrid/hex_grid.gd").new()
var ico = icosahedron.icosahedron


func grided_faces(n: int) -> Array:
	var array: Array = []
	array += [hex.hex_grid(ico[1],  ico[0],  ico[2],  n)]
	array += [hex.hex_grid(ico[2],  ico[0],  ico[3],  n)]
	array += [hex.hex_grid(ico[3],  ico[0],  ico[4],  n)]
	array += [hex.hex_grid(ico[4],  ico[0],  ico[5],  n)]
	array += [hex.hex_grid(ico[5],  ico[0],  ico[1],  n)]
	array += [hex.hex_grid(ico[8],  ico[6],  ico[7],  n)]
	array += [hex.hex_grid(ico[9],  ico[6],  ico[8],  n)]
	array += [hex.hex_grid(ico[10], ico[6],  ico[9],  n)]
	array += [hex.hex_grid(ico[11], ico[6],  ico[10], n)]
	array += [hex.hex_grid(ico[7],  ico[6],  ico[11], n)]
	array += [hex.hex_grid(ico[3],  ico[8],  ico[2],  n)]
	array += [hex.hex_grid(ico[4],  ico[9],  ico[3],  n)]
	array += [hex.hex_grid(ico[5],  ico[10], ico[4],  n)]
	array += [hex.hex_grid(ico[1],  ico[11], ico[5],  n)]
	array += [hex.hex_grid(ico[2],  ico[7],  ico[1],  n)]
	array += [hex.hex_grid(ico[7],  ico[2],  ico[8],  n)]
	array += [hex.hex_grid(ico[8],  ico[3],  ico[9],  n)]
	array += [hex.hex_grid(ico[9],  ico[4],  ico[10], n)]
	array += [hex.hex_grid(ico[10], ico[5],  ico[11], n)]
	array += [hex.hex_grid(ico[11], ico[1],  ico[7],  n)]
	return array

func inner_faces(n: int) -> Array:
	var array: Array = []
	for i in range(20):
		array += (hex.order_inner_hex(grided_faces(n)[i], n))
	return array

func pentagons(n: int) -> Array:
	var array: Array = []
	var fa: Array = grided_faces(n)
	var tip: int = len(fa[0]) - 2 # tip
	var b1: int = n + 1           # base1
	var b2: int = 2 * n           # base2
	array.append([ico[0],  (fa[4])[tip],  (fa[3])[tip],  (fa[2])[tip],  (fa[1])[tip],  (fa[0])[tip]])
	array.append([ico[1],  (fa[4])[b2],   (fa[0])[b1],   (fa[14])[b2],  (fa[19])[tip], (fa[13])[b1]])
	array.append([ico[2],  (fa[0])[b2],   (fa[1])[b1],   (fa[10])[b2],  (fa[15])[tip], (fa[14])[b1]])
	array.append([ico[3],  (fa[1])[b2],   (fa[2])[b1],   (fa[11])[b2],  (fa[16])[tip], (fa[10])[b1]])
	array.append([ico[4],  (fa[2])[b2],   (fa[3])[b1],   (fa[12])[b2],  (fa[17])[tip], (fa[11])[b1]])
	array.append([ico[5],  (fa[3])[b2],   (fa[4])[b1],   (fa[13])[b2],  (fa[18])[tip], (fa[12])[b1]])
	array.append([ico[6],  (fa[5])[tip],  (fa[6])[tip],  (fa[7])[tip],  (fa[8])[tip],  (fa[9])[tip]])
	array.append([ico[7],  (fa[14])[tip], (fa[15])[b1],  (fa[5])[b2],   (fa[9])[b1],   (fa[19])[b2]])
	array.append([ico[8],  (fa[10])[tip], (fa[16])[b1],  (fa[6])[b2],   (fa[5])[b1],   (fa[15])[b2]])
	array.append([ico[9],  (fa[11])[tip], (fa[17])[b1],  (fa[7])[b2],   (fa[6])[b1],   (fa[16])[b2]])
	array.append([ico[10], (fa[12])[tip], (fa[18])[b1],  (fa[8])[b2],   (fa[7])[b1],   (fa[17])[b2]])
	array.append([ico[11], (fa[13])[tip], (fa[19])[b1],  (fa[9])[b2],   (fa[8])[b1],   (fa[18])[b2]])
	return array

func hex_on_line_tips(y:float, left_face: PoolVector3Array, right_face: PoolVector3Array, n: int) -> PoolVector3Array:
	# makes a hexagon on a common lines of two triangles that have the same tip
	var array: PoolVector3Array = [0, 1, 2, 3, 4, 5, 6]
	var right_center: float = 3 * y * (n - ((y - 1) / 2))
	var left_center: float = right_center + (n - y)
	array[0] = right_face[right_center]
	array[1] = right_face[right_center + n - y + 1]
	array[2] = right_face[right_center - (n - y)]
	array[3] = right_face[right_center - (n - y) * 2 - 1]
	array[4] = left_face[left_center - (n - y) * 2 - 1]
	array[5] = left_face[left_center - (n - y + 1)]
	array[6] = left_face[left_center + (n - y)]
	return array

func hex_on_line_bottoms(x: float, top_face: PoolVector3Array, bottom_face: PoolVector3Array, n: int) -> PoolVector3Array:
	var array: PoolVector3Array = [0, 1, 2, 3, 4, 5, 6]
	var top_center: float = x
	var bottom_center: float = n - x
	array[0] = top_face[top_center]
	array[1] = top_face[top_center + n]
	array[2] = top_face[top_center + n * 2]
	array[3] = top_face[top_center + n + 1]
	array[4] = bottom_face[bottom_center + n]
	array[5] = bottom_face[bottom_center + n * 2]
	array[6] = bottom_face[bottom_center + n + 1]
	return array

func hex_on_line_sides_clockwise(y: float, left_face: PoolVector3Array, right_face: PoolVector3Array, n: int) -> PoolVector3Array:
	var array: PoolVector3Array = [0, 1, 2, 3, 4, 5, 6]
	var left_center: float = 3 * (n - y) * (n - ((n - y - 1) / 2))
	var right_center: float = 3 * y * (n - ((y - 1) / 2))
	array[0] = right_face[right_center]
	array[1] = right_face[right_center + n - y + 1]
	array[2] = right_face[right_center - (n - y)]
	array[3] = right_face[right_center - (n - y) * 2 - 1]
	array[4] = left_face[left_center + y + 1]
	array[5] = left_face[left_center - y]
	array[6] = left_face[left_center - y * 2 - 1]
	return array

func hex_on_line_sides_anticlockwise(y: float, left_face: PoolVector3Array, right_face: PoolVector3Array, n: int) -> PoolVector3Array:
	var array: PoolVector3Array = [0, 1, 2, 3, 4, 5, 6]
	var left_center: float = 3 * y * (n - ((y - 1) / 2)) + (n - y)
	var right_center: float = 3 * (n - y) * (n - (((n - y) - 1) / 2)) + y
	array[0] = right_face[right_center]
	array[1] = right_face[right_center - y * 2 - 1]
	array[2] = right_face[right_center - y - 1]
	array[3] = right_face[right_center + y]
	array[4] = left_face[left_center - (n - y) * 2 - 1]
	array[5] = left_face[left_center - (n - y) - 1]
	array[6] = left_face[left_center + (n - y)]
	return array

func line_hexagons(face_one: PoolVector3Array, face_two: PoolVector3Array, n: int) -> Array:
	var array: Array = []
	if face_one[len(face_one) - 1].is_equal_approx(face_two[len(face_two) - 1]):
		for y in range(1, n):
			array += [hex_on_line_tips(y, face_one, face_two, n)]
	elif face_one[0].is_equal_approx(face_two[n]):
		for x in range(1, n):
			array += [hex_on_line_bottoms(x, face_one, face_two, n)]
	elif face_one[0].is_equal_approx(face_two[len(face_two) - 1]):
		for y in range(1, n):
			array += [hex_on_line_sides_clockwise(y, face_one, face_two, n)]
	elif face_one[len(face_one) - 1].is_equal_approx(face_two[n]):
		for y in range(1, n):
			array += [hex_on_line_sides_anticlockwise(y, face_one, face_two, n)]
	return array

func edges(n: int) -> Array:
	var array: Array = []
	var faces : Array = grided_faces(n)
	array += (line_hexagons(faces[0],  faces[1],  n)) # top edge
	array += (line_hexagons(faces[1],  faces[2],  n)) # top edge
	array += (line_hexagons(faces[2],  faces[3],  n)) # top edge
	array += (line_hexagons(faces[3],  faces[4],  n)) # top edge
	array += (line_hexagons(faces[4],  faces[0],  n)) # top edge
	array += (line_hexagons(faces[0],  faces[14], n)) # top side edge
	array += (line_hexagons(faces[1],  faces[10], n)) # top side edge
	array += (line_hexagons(faces[2],  faces[11], n)) # top side edge
	array += (line_hexagons(faces[3],  faces[12], n)) # top side edge
	array += (line_hexagons(faces[4],  faces[13], n)) # top side edge
	array += (line_hexagons(faces[9],  faces[8],  n)) # bottom edge
	array += (line_hexagons(faces[8],  faces[7],  n)) # bottom edge
	array += (line_hexagons(faces[7],  faces[6],  n)) # bottom edge
	array += (line_hexagons(faces[6],  faces[5],  n)) # bottom edge
	array += (line_hexagons(faces[5],  faces[9],  n)) # bottom edge
	array += (line_hexagons(faces[9], faces[19],  n)) # bottom side edge
	array += (line_hexagons(faces[8], faces[18],  n)) # bottom side edge
	array += (line_hexagons(faces[7], faces[17],  n)) # bottom side edge
	array += (line_hexagons(faces[6], faces[16],  n)) # bottom side edge
	array += (line_hexagons(faces[5], faces[15],  n)) # bottom side edge
	array += (line_hexagons(faces[19], faces[13], n)) # side edge clockwise
	array += (line_hexagons(faces[18], faces[12], n)) # side edge clockwise
	array += (line_hexagons(faces[17], faces[11], n)) # side edge clockwise
	array += (line_hexagons(faces[16], faces[10], n)) # side edge clockwise
	array += (line_hexagons(faces[15], faces[14], n)) # side edge clockwise
	array += (line_hexagons(faces[14], faces[19], n)) # side edge anticlockwise
	array += (line_hexagons(faces[10], faces[15], n)) # side edge anticlockwise
	array += (line_hexagons(faces[11], faces[16], n)) # side edge anticlockwise
	array += (line_hexagons(faces[12], faces[17], n)) # side edge anticlockwise
	array += (line_hexagons(faces[13], faces[18], n)) # side edge anticlockwise
	return array

func pre_projection_grid(n: int) -> Array:
	var array: Array = []
	array += pentagons(n)
	array += inner_faces(n)
	array += edges(n)
	return array
