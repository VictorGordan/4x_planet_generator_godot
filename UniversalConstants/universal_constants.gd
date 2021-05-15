extends Node

const n: int = 21 # (n - 1) is the smallest number of hexagons between two pentagons
# duel: n = 11 (1212 polys)
# tiny: n = 15 (2252 polys)
# small: n = 19 (3612 polys)
# standard: n = 21 (4412 polys)
# large: n = 24 (5762 polys)
# huge: n = 26 (6762 polys)
# colossal: n = 32 (10242 polys)
const polys: int = 4412 # make function to change this according to n

const num_plates: int = 14 # number of tectonic plates
# between 7 and 21

var seed_val: int = 123456789 # seed value for world generation
#337875 interesting seed

# finds the value of r by using n
const v1: Vector3 = Vector3(0.5, 0, (1 + (sqrt(5) - 1) / 2) / 2)
const v2: Vector3 = Vector3(
	-1 / (2 * float(n)), 
	sin(0.5 * acos(-sqrt(5) / 3)) / (2 * sqrt(3) * n), 
	-cos(0.5 * acos(-sqrt(5) / 3)) / (2 * sqrt(3) * n))
const v3:Vector3 = Vector3(
	-1 / (2 * float(n)), 
	-sin(0.5 * acos(-sqrt(5) / 3)) / (2 * sqrt(3) * n), 
	-cos(0.5 * acos(-sqrt(5) / 3)) / (2 * sqrt(3) * n))
var angle: float = (v1 + v2).angle_to(v1 + v3)
var r: float = sqrt(1 / (2 * ( 1 - cos(angle)))) # radius of Goldberg Polyhedron
