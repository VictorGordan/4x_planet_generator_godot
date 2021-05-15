extends Node

var polyhedron = load("res://GoldbergPolyhedronGenerator/goldberg_polyhedron.gd").new()


func generate_adj_sets(n: int) -> Array:
	# find the neighbours of a polygon and puts them into an array
	# the first polygon in the array is the one whose neighbours are searched for
	var arr = polyhedron.goldberg_polyhedron(n)
	var array: Array =[]
	for i in range(len(arr)):
		var current_poly: PoolVector3Array = arr[i]
		var new_array: Array = [i] # contains current_poly index and neighbours indices
		var current_center: Vector3 = current_poly[0]
		for j in range(len(arr)):
			if arr[j][0] != current_center and current_center.distance_squared_to(arr[j][0]) < 2.5 * 2.5 :
				new_array += [j]
		array += [new_array]
	return array

func assign_adj_array() -> Array:
	var array: Array
	if [11, 15, 19, 21, 24, 26, 32].has(constant.n):
		var file = File.new()
		
		if constant.n == 11:
			file.open("res://AdjacentFunctions/AdjacentPolys/duel.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 15:
			file.open("res://AdjacentFunctions/AdjacentPolys/tiny.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 19:
			file.open("res://AdjacentFunctions/AdjacentPolys/small.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 21:
			file.open("res://AdjacentFunctions/AdjacentPolys/standard.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 24:
			file.open("res://AdjacentFunctions/AdjacentPolys/large.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 26:
			file.open("res://AdjacentFunctions/AdjacentPolys/huge.adj", File.READ)
			array = file.get_var()
			file.close()
		elif constant.n == 32:
			file.open("res://AdjacentFunctions/AdjacentPolys/colossal.adj", File.READ)
			array = file.get_var()
			file.close()
	else:
		array = generate_adj_sets(constant.n)
	return array

var adj_sets: Array = assign_adj_array()

func neigh(idx: int) -> Array:
	return adj_sets[idx]

