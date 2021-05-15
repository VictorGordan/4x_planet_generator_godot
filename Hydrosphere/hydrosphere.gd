extends Node

var continents = load("res://MapTypes/continents.gd").new()
var polyhedron = load("res://GoldbergPolyhedronGenerator/goldberg_polyhedron.gd").new()

var tiles: Array = continents.tiles

func tropics_and_winds() -> void:
	continents.height_gen()
	var goldberg: Array = polyhedron.goldberg_polyhedron(constant.n)
	for i in range(constant.polys):
		var crnt_center: Vector3 = goldberg[i][0]
		var angle: float = crnt_center.angle_to(Vector3(crnt_center[0], 0, crnt_center[2]))
		if angle <= 0.523599:
			tiles[i]["tropics"] = "tropical"
			
		elif angle <= 1.0472:
			tiles[i]["tropics"] = "temperate"
		else:
			tiles[i]["tropics"] = "polar"
