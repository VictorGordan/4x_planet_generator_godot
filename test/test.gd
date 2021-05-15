extends MeshInstance


var project = load("res://GoldbergPolyhedronGenerator/goldberg_polyhedron.gd").new()
var adjacent = load("res://AdjacentFunctions/adjacent.gd").new()
var plates = load("res://TectonicPlates/tectonic_plates.gd").new()
var cont = load("res://MapTypes/continents.gd").new()
var hydro = load("res://Hydrosphere/hydrosphere.gd").new()


var polyhedron: Array = project.goldberg_polyhedron(constant.n)

func _ready():
	hydro.tropics_and_winds()
	
	for i in range(constant.polys):
		if hydro.tiles[i]["height"] == 4:
			draw.polygons([polyhedron[i]], self, Color(0.2, 0, 0))
		elif hydro.tiles[i]["height"] == 3:
			draw.polygons([polyhedron[i]], self, Color(0.4, 0.2, 0))
		elif hydro.tiles[i]["height"] == 2:
			draw.polygons([polyhedron[i]], self, Color(0.65, 0.6, 0.4))
		elif hydro.tiles[i]["height"] == 1:
			draw.polygons([polyhedron[i]], self, Color(0.65, 0.8, 0.4))
		elif hydro.tiles[i]["height"] == 0:
			draw.polygons([polyhedron[i]], self, Color(0.8, 0.8, 0.6))
		elif hydro.tiles[i]["height"] == -1:
			draw.polygons([polyhedron[i]], self, Color(0.4, 0.6, 1.0))
		elif hydro.tiles[i]["height"] == -2:
			draw.polygons([polyhedron[i]], self, Color(0.2, 0.3, 0.9))
		elif hydro.tiles[i]["height"] == -3:
			draw.polygons([polyhedron[i]], self, Color(0.0, 0.0, 0.5))
		elif hydro.tiles[i]["height"] == -4:
			draw.polygons([polyhedron[i]], self, Color(0.0, 0.0, 0.4))
		elif hydro.tiles[i]["height"] == -42:
			draw.polygons([polyhedron[i]], self, Color(1.0, 0.0, 0.0))
			
		#if hydro.tiles[i]["tropics"] == "tropical":
		#	draw.polygons([polyhedron[i]], self, Color(1, 0, 0))
		#elif hydro.tiles[i]["tropics"] == "temperate":
		#	draw.polygons([polyhedron[i]], self, Color(0, 1, 0))
		#elif hydro.tiles[i]["tropics"] == "polar":
		#	draw.polygons([polyhedron[i]], self, Color(0, 0, 1))








