extends Node

var goldberg_polyhedron = load("res://GoldbergPolyhedronGenerator/goldberg_polyhedron.gd").new()
var rng = RandomNumberGenerator.new()


var plates_idx: Array = [] # plate idx for each poly
var tect_plates: Array = range(constant.num_plates) # plates with indeces in separat arrays
var adj_plates: Array = range(constant.num_plates) # adjacent plates arrays
var total: int = 0 #total amount of polys generated for plates


func adj_polys(plates: Array, i: int) -> void:
	# outputs the adjacent polys to an array of polys
	for j in range(len(plates[i])):
		var crnt_poly: int = plates[i][j]
		var crnt_adj: Array = adj.neigh(crnt_poly)
		for k in range(1, len(crnt_adj)):
			var perc: float = float(total) / len(plates_idx)
			var distortion: float = 1
			if perc < 0.25:
				distortion = 0.1
			elif perc < 0.50:
				distortion = 0.2   #tweak distortions some time maybe
			elif perc < 1.00:
				distortion = 0.7
			if not (plates_idx[crnt_adj[k]] is int) and randf() < distortion: 
				plates_idx[crnt_adj[k]] = i
				tect_plates[i] += [crnt_adj[k]]
				total += 1
			if plates_idx[crnt_adj[k]] is int and i != j:
				if not adj_plates[i].has(plates_idx[crnt_adj[k]]):
					adj_plates[i] += [plates_idx[crnt_adj[k]]]

func plates_centers(num:int) -> void:
	# generates the centers of the plates
	plates_idx.resize(len(goldberg_polyhedron.goldberg_polyhedron(constant.n)))
	var number: int = 0
	var done: Array = range(num)
	while number != num:
		for i in range(num):
			if done[i] is String:
				continue
			var ran_num: int = rng.randi_range(0, len(plates_idx) - 1)
			if not plates_idx[ran_num] is int and plates_idx[ran_num] != "center_adj":
				plates_idx[ran_num] = i
				total += 1
				tect_plates[i] = [ran_num]
				done[i] = "done"
				number += 1
				var adj_polys: Array = adj.neigh(ran_num)
				for j in range(1, len(adj_polys)):
					plates_idx[adj_polys[j]] = "center_adj"

func tectonic_plates(num:int) -> void:
	#generates tectonic plates
	rng.set_seed(constant.seed_val)
	plates_centers(num)
	for i in range(num):
		adj_plates[i] = [i]
	while total != len(plates_idx):
		for i in range(num):
			adj_polys(tect_plates, i)

"""
# code for rendering plates to adjust distortion variables
var polyhedron: Array = project.goldberg_polyhedron(constant.n)
var centers: Array = plates.tect_plates
	plates.tectonic_plates(constant.num_plates)
	for i in range(len(centers)):
		var color: Color = Color(randf(), randf(), randf())
		for j in range(len(centers[i])):
			draw.polygons([polyhedron[centers[i][j]]], self, color)
"""
