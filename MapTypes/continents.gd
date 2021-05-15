extends Node

var tectonic_plates = load("res://TectonicPlates/tectonic_plates.gd").new()
var polyhedron = load("res://GoldbergPolyhedronGenerator/goldberg_polyhedron.gd").new()
var rng = RandomNumberGenerator.new()

var plates: Array = tectonic_plates.tect_plates
var types: PoolStringArray = helper.null_array(constant.num_plates)
var size_order: Array = []
var sizes: Array = range(constant.num_plates)
var adj_plates: Array = tectonic_plates.adj_plates
var masses: Array = helper.null_array(constant.polys) # helper var for func mass
var inter: Array = []
var tiles: Array = []

func tiles_setup() -> void:
	for _i in range(constant.polys):
		var tile: Dictionary = {
			height = -42
		}
		tiles.append(tile)

func sizes_order() -> void:
	# gives order of plates in array from largest to smallest
	tectonic_plates.tectonic_plates(constant.num_plates)
	for i in range(constant.num_plates):
		sizes[i] = len(plates[i])
	var sizes_temp: Array = sizes.duplicate(true)
	var largest: int = 0
	for _j in range(constant.num_plates):
		for k in range(len(sizes_temp)):
			if sizes_temp[k] > sizes_temp[largest]:
				largest = k
			if k == len(sizes_temp) - 1:
				size_order.append(largest)
				sizes_temp[largest] = 0

func order_adj(idx: int) -> void:
	# orders adj plates from largest to smallest
	var new_adj: Array = [idx]
	for i in range(constant.num_plates):
		if adj_plates[idx].has(size_order[i]) and size_order[i] != idx:
			new_adj.append(size_order[i])
	adj_plates[idx] = new_adj
func order_adj_plates() -> void:
	for i in range(constant.num_plates):
		order_adj(i)

func main_ocean() -> void:
	# generates main ocean by giving type "oceanic" to biggest plate and
	# the surrounding smallest plates
	types[size_order[0]] = "oceanic"
	var ocean_polys: int = sizes[size_order[0]]
	var adj_ocean: Array = adj_plates[size_order[0]]
	var idx: int = len(adj_ocean) - 1
	var perc: float = float(ocean_polys) / constant.polys
	var last: int = constant.num_plates
	while perc < 0.3:
		if idx == 0:
			if types[size_order[last]] != "oceanic":
				types[size_order[last]] = "oceanic"
				ocean_polys += sizes[size_order[last]]
				last -= 1
				perc = float(ocean_polys) / constant.polys
		else:
			types[adj_ocean[idx]] = "oceanic"
			ocean_polys += sizes[adj_ocean[idx]]
			idx -= 1
			perc = float(ocean_polys) / constant.polys
func types_asg() -> void:
	for i in range(constant.num_plates):
		if types[i] != "oceanic":
			types[i] = "continental"

func adj_line(tplates: Array, plate1_idx: int, plate2_idx: int) -> Array:
	# gives all adj tiles of plate2 that are on plate1
	var adj_line: Array = []
	var plates_idx: Array = tectonic_plates.plates_idx
	for i in range(len(tplates[plate1_idx])):
		var crnt_poly: int = tplates[plate1_idx][i]
		var crnt_adj: Array = adj.neigh(crnt_poly)
		for j in range(1, len(crnt_adj)):
			if plates_idx[crnt_adj[j]] == plate2_idx and masses[crnt_poly] != plate1_idx:
				adj_line.append(crnt_poly)
				masses[crnt_poly] = plate1_idx
	return adj_line

func mass(tplates: Array, plate1_idx: int, plate2_idx: int, max_perc: float, type: String, distortion: float) -> void:
	# generates mass of land or water on plate1 such that it is adj to plate2
	if max_perc == 0.00:
		return
	var mass: Array = adj_line(tplates, plate1_idx, plate2_idx)
	var perc: float = float(len(mass)) / len(tplates[plate1_idx])
	var plates_idx: Array = tectonic_plates.plates_idx
	while perc < max_perc: # max_perc should be a bit smaller than what is desired
		var temp_add: Array = []
		for i in range(len(mass)):
			var crnt_adj: Array = adj.neigh(mass[i])
			for j in range(1, len(crnt_adj)):
				if masses[crnt_adj[j]] == null and plates_idx[crnt_adj[j]] == plate1_idx:
					if rng.randf() < distortion:
						temp_add.append(crnt_adj[j])
						masses[crnt_adj[j]] = plate1_idx
			if i == len(mass) - 1:
				mass += temp_add
				perc = float(len(mass)) / len(tplates[plate1_idx])
	for i in range(len(mass)):
		if tiles[mass[i]]["height"] == -42:
			tiles[mass[i]]["height"] = 0
		if type == "sea" and tiles[mass[i]]["height"] != -4:
			tiles[mass[i]]["height"] = tiles[mass[i]]["height"] - 1
		elif type == "land" and tiles[mass[i]]["height"] != 4:
			tiles[mass[i]]["height"] = tiles[mass[i]]["height"] + 1
	masses = helper.null_array(constant.polys)

func common_adj(plate1_idx: int, plate2_idx: int) -> Array:
	# returns common adj plate of plate1 and plate2 which is not notplate_idx
	var common: Array = []
	for i in range(1, len(adj_plates[plate1_idx])):
		for j in range(1, len(adj_plates[plate2_idx])):
			if adj_plates[plate1_idx][i] == adj_plates[plate2_idx][j]:
				common.append(adj_plates[plate1_idx][i])
	return common

func opposite_plates(plate1_idx: int, plate2_idx) -> Array:
	# returns non common plates of plate2 with regards to plate 1
	var opposite: Array = []
	var plate2_adj: Array = adj_plates[plate2_idx].duplicate(true)
	var common: Array = common_adj(plate1_idx, plate2_idx)
	for i in range(1, len(plate2_adj)):
		if not common.has(plate2_adj[i]):
			opposite.append(plate2_adj[i])
	return opposite

func interactions() -> void:
	# assigns types of interactions between plates
	inter = adj_plates.duplicate(true)
	var num_diverg_ocean: int = 0
	var num_scdn_ocean: int = 0
	for i in range(constant.num_plates):
		if types[i] == "oceanic":
			for j in range(1, len(inter[i])):
				if inter[i][j] is int:
					var crnt_adj: int = inter[i][j]
					if types[crnt_adj] == "oceanic":
						inter[crnt_adj][inter[crnt_adj].find(i)] = "transform"
						inter[i][j] = "transform"
					elif types[crnt_adj] == "continental":
						if num_diverg_ocean != 2:
							inter[crnt_adj][inter[crnt_adj].find(i)] = "divergent"
							inter[i][j] = "divergent"
							num_diverg_ocean += 1
						elif num_scdn_ocean != 3:
							inter[crnt_adj][inter[crnt_adj].find(i)] = "convergent"
							inter[i][j] = "convergent"
							var opp: Array = opposite_plates(i, crnt_adj)
							for k in range(len(opp)):
								inter[opp[k]][inter[opp[k]].find(crnt_adj)] = "divergent"
								inter[crnt_adj][inter[crnt_adj].find(opp[k])] = "divergent"
							num_scdn_ocean += 1
						else:
							inter[crnt_adj][inter[crnt_adj].find(i)] = "convergent"
							inter[i][j] = "convergent"
		if types[i] == "continental":
			for j in range(1, len(inter[i])):
				if not inter[i][j] is int and inter[i][j] == "divergent":
					var crnt_adj: int = adj_plates[i][j]
					var opp: Array = opposite_plates(i, crnt_adj)
					for k in range(len(opp)):
						if inter[opp[k]][inter[opp[k]].find(crnt_adj)] is int:
							inter[opp[k]][inter[opp[k]].find(crnt_adj)] = "convergent"
						if inter[crnt_adj][inter[crnt_adj].find(opp[k])] is int:
							inter[crnt_adj][inter[crnt_adj].find(opp[k])] = "convergent"
				elif not inter[i][j] is int and inter[i][j] == "convergent":
					var crnt_adj: int = adj_plates[i][j]
					var opp: Array = opposite_plates(i, crnt_adj)
					for k in range(len(opp)):
						if inter[opp[k]][inter[opp[k]].find(crnt_adj)] is int:
							inter[opp[k]][inter[opp[k]].find(crnt_adj)] = "divergent"
						if inter[crnt_adj][inter[crnt_adj].find(opp[k])] is int:
							inter[crnt_adj][inter[crnt_adj].find(opp[k])] = "divergent"
	for i in range(constant.num_plates):
		var crnt_adj: Array = adj_plates[i]
		for j in range(1, len(crnt_adj)):
			if inter[i][j] is int:
				inter[inter[i][j]][inter[inter[i][j]].find(i)] = "transform"
				inter[i][j] = "transform"

func per_tiles(height: int, criteria: String) -> float:
	var num_tiles: int = 0
	for i in range(constant.polys):
		if criteria == "less":
			if tiles[i]["height"] < height:
				num_tiles += 1
		elif criteria == "equal":
			if tiles[i]["height"] == height:
				num_tiles += 1
		elif criteria == "more":
			if tiles[i]["height"] > height:
				num_tiles += 1
	var per: float = float(num_tiles) / constant.polys
	return per

func mountain_range(plate_idx: int, length: int) -> void:
	var mnt_range: Array = []
	var exclude: Array = []
	for i in range(len(plates[plate_idx])):
		var crnt_tile: int = plates[plate_idx][i]
		var crnt_adj: Array = adj.neigh(crnt_tile)
		var all: int = 0
		for j in range(len(crnt_adj)):
			if tiles[crnt_adj[j]]["height"] == 1:
				all += 1
		if all == len(crnt_adj):
			while length != len(mnt_range):
				mnt_range.append(crnt_tile)
				var chosen: int = 0
				var skip: int = 0
				var ran_num: float = randf()
				for j in range(1, len(crnt_adj)):
					if not exclude.has(crnt_adj[j]) and chosen == 0 and skip == 2 and ran_num < 0.5:
						chosen = crnt_adj[j]
					elif not exclude.has(crnt_adj[j]) and chosen == 0 and skip == 1 and ran_num > 0.5:
						chosen = crnt_adj[j]
					elif not exclude.has(crnt_adj[j]) and chosen == 0:
						skip += 1
				for j in range(len(crnt_adj)):
					if not exclude.has(crnt_adj[j]) and crnt_adj[j] != chosen:
						exclude.append(crnt_adj[j])
				crnt_tile = chosen
				crnt_adj = adj.neigh(crnt_tile)
			break
	for i in range(len(mnt_range)):
		tiles[mnt_range[i]]["height"] = 3

func island_range(plate_idx: int, length: int) -> void:
	var mnt_range: Array = []
	var exclude: Array = []
	for i in range(len(plates[plate_idx])):
		var crnt_tile: int = plates[plate_idx][i]
		var crnt_adj: Array = adj.neigh(crnt_tile)
		var all: int = 0
		for j in range(len(crnt_adj)):
			if tiles[crnt_adj[j]]["height"] == -4:
				all += 1
		if all == len(crnt_adj):
			while length != len(mnt_range):
				if randf() < 0.25:
					mnt_range.append(crnt_tile)
				var chosen: int = 0
				for j in range(1, len(crnt_adj)):
					if not exclude.has(crnt_adj[j]) and chosen == 0:
						chosen = crnt_adj[j]
				for j in range(len(crnt_adj)):
					if not exclude.has(crnt_adj[j]) and crnt_adj[j] != chosen:
						exclude.append(crnt_adj[j])
				crnt_tile = chosen
				crnt_adj = adj.neigh(crnt_tile)
			break
	for i in range(len(mnt_range)):
		if i < 2:
			tiles[mnt_range[i]]["height"] = 3
		elif i < 5:
			tiles[mnt_range[i]]["height"] = 2
		elif i < 10:
			tiles[mnt_range[i]]["height"] = 1

func height_gen() -> void:
	# generates a rough height for all tiles that will be adjusted later
	tiles_setup()
	sizes_order()
	order_adj_plates()
	main_ocean()
	types_asg()
	interactions()
	for i in range(constant.num_plates):
		if types[i] == "oceanic":
			for j in range(len(plates[i])):
				tiles[plates[i][j]]["height"] = -4
	
	for i in range(constant.num_plates):
		if types[i] == "continental":
			for j in range(len(plates[i])):
				tiles[plates[i][j]]["height"] = 1
	
	for i in range(constant.num_plates):
		var crnt_plt: int = i
		var crnt_adj: Array = adj_plates[crnt_plt]
		for j in range(1, len(crnt_adj)):
			var crnt_adj_plt: int = crnt_adj[j]
			if inter[crnt_plt][j] == "convergent":
				if types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.15, "land", 0.10)
				elif types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "continental":
					mass(plates, crnt_plt, crnt_adj_plt, 0.35, "land", 0.40)
					mass(plates, crnt_plt, crnt_adj_plt, 0.15, "land", 0.25)
					mass(plates, crnt_plt, crnt_adj_plt, 0.10, "land", 0.25)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.25, "land", 0.35)
					mass(plates, crnt_plt, crnt_adj_plt, 0.15, "land", 0.10)
					mass(plates, crnt_plt, crnt_adj_plt, 0.00, "land", 0.10)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "continental":
					mass(plates, crnt_plt, crnt_adj_plt, 0.25, "land", 0.35)
					if randf() < 0.50:
						mass(plates, crnt_plt, crnt_adj_plt, 0.10, "land", 0.10)
			elif inter[crnt_plt][j] == "divergent":
				if types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.00, "land", 0.30)
				elif types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "continental":
					mass(plates, crnt_plt, crnt_adj_plt, 0.15, "land", 0.10)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.35, "sea", 0.35)
					mass(plates, crnt_plt, crnt_adj_plt, 0.25, "sea", 0.10)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "continental":
					mass(plates, crnt_plt, crnt_adj_plt, 0.60, "sea", 0.55)
					mass(plates, crnt_plt, crnt_adj_plt, 0.45, "sea", 0.40)
					mass(plates, crnt_plt, crnt_adj_plt, 0.35, "sea", 0.20)
					mass(plates, crnt_plt, crnt_adj_plt, 0.25, "sea", 0.10)
					mass(plates, crnt_plt, crnt_adj_plt, 0.15, "sea", 0.10)
			elif inter[crnt_plt][j] == "transform":
				if types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.00, "land", 0.20)
				elif types[crnt_plt] == "oceanic" and types[crnt_adj_plt] == "continental":
					mass(plates, crnt_plt, crnt_adj_plt, 0.35, "land", 0.40)
					mass(plates, crnt_plt, crnt_adj_plt, 0.25, "land", 0.25)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "oceanic":
					mass(plates, crnt_plt, crnt_adj_plt, 0.35, "sea", 0.25)
				elif types[crnt_plt] == "continental" and types[crnt_adj_plt] == "continental":
					if randf() > 0.75:
						mass(plates, crnt_plt, crnt_adj_plt, 0.20, "sea", 0.25)
						mass(plates, crnt_plt, crnt_adj_plt, 0.15, "sea", 0.15)
	
	var len_mountains: int = 7
	if constant.n < 21:
		len_mountains = 5
	for i in range(constant.num_plates):
		if types[i] == "continental":
			if randf() > 0.25:
				mountain_range(i, rng.randi_range(2, len_mountains))
	
	var one_per: float = float(1) / constant.polys
	
	var per_sea: float = per_tiles(0, "less")
	while per_sea > 0.70:
		for i in range(constant.polys):
			if per_sea > 0.70:
				if (tiles[i]["height"] == -1 or tiles[i]["height"] == -2):
					if randf() < 0.35:
						tiles[i]["height"] += 1
						if tiles[i]["height"] >= 0:
							per_sea -= one_per
			else:
				break
	while per_sea < 0.65:
		for i in range(constant.polys):
			if per_sea < 0.65:
				if tiles[i]["height"] == 0:
					if randf() < 0.35:
						tiles[i]["height"] -= 1
						if tiles[i]["height"] < 0:
							per_sea += one_per
			else:
				break
	var per_mountains: float = per_tiles(2, "more")
	while per_mountains >= 0.05:
		for i in range(constant.polys):
			if per_mountains >= 0.05:
				if tiles[i]["height"] > 2:
					if randf() < 0.65:
						tiles[i]["height"] -= 1
						if tiles[i]["height"] < 3:
							per_mountains -= one_per
			else:
				break
	var per_farmable: float = per_tiles(1, "equal") + per_tiles(0, "equal")
	while per_farmable < 0.15:
		for i in range(constant.polys):
			if per_farmable < 0.15:
				if tiles[i]["height"] == 2:
					if randf() < 0.75:
						tiles[i]["height"] -= 1
						per_farmable += one_per
			else:
				break
	var per_hills: float = per_tiles(2, "equal")
	while per_hills > 0.14:
		for i in range(constant.polys):
			if per_hills > 0.14:
				if tiles[i]["height"] == 2:
					if randf() < 0.35:
						tiles[i]["height"] -= 1
						per_hills -= one_per
			else:
				break
	var per_lowlands: float = per_tiles(0, "equal")
	while per_lowlands > 0.08:
		for i in range(constant.polys):
			if per_lowlands > 0.08:
				if tiles[i]["height"] == 0:
					if randf() < 0.35:
						tiles[i]["height"] += 1
						per_lowlands -= one_per
			else:
				break
	
	var len_islands: int = 7
	if constant.n < 21:
		len_islands = 3
	island_range(size_order[0], len_islands)









