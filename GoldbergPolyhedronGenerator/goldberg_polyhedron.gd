extends Node

var grid = load(self.get_script().get_path().get_base_dir() + "/GridIcosahedron/grid_icosahedron.gd").new()



func projection(array: Array) -> Array:
	# takes array made of multiple PoolVector3Array
	# then projects them onto a sphere of radius r
	# r is such that the side of a pentagon is equal to 1
	var theta = array[0][1].angle_to(array[0][2])
	var r = sqrt(1 / (2 * ( 1 - cos(theta))))
	for i in range(len(array)):
		for j in range(len(array[i])):
			var c: float = r / array[i][j].length()
			array[i][j] = array[i][j] * c
	return array

func adjust_centers(array: Array) -> Array:
	# takes center of polygon and puts it in plane with its vertices
	for i in range(len(array)):
		var center: Vector3 = array[i][0]
		var ref_vec: Vector3 = array[i][1]
		var dot_product: float = ref_vec.dot(center)
		var c: float = dot_product / center.length_squared()
		array[i][0] = center * c
	return array

func goldberg_polyhedron(n: int) -> Array:
	# generates a goldberg_polyhedron of divisions n
	var array: Array
	
	if [11, 15, 19, 21, 24, 26, 32].has(n):
		var file = File.new()
		
		if constant.n == 11:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/duel.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 15:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/tiny.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 19:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/small.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 21:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/standard.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 24:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/large.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 26:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/huge.size", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 32:
			file.open("res://GoldbergPolyhedronGenerator/MapSizes/colossal.size", File.READ)
			array = file.get_var()
			file.close()
	else:
			array = grid.pre_projection_grid(n)
			array = projection(array)
			array = adjust_centers(array)
	return array

