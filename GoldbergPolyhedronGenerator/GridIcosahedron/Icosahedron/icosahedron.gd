extends Node

var a: float = 1                  # short side of golden rectangle
var b: float = (sqrt(5) - 1) / 2  # b = long side of golden rectangle - a
var side: float = a + b           # long side of golden rectangle

var ico: PoolVector3Array = [
	Vector3(0, side / 2, 0.5), # top/bottom points
	Vector3(-0.5, 0, side / 2), # front/back side point
	Vector3(0.5, 0, side / 2), # front/back side point
	Vector3(side / 2, 0.5, 0), # left/right side points
	Vector3(0, side / 2, -0.5), # top/bottom points
	Vector3(-side / 2, 0.5, 0), # left/right side points
	Vector3(0, -side / 2, -0.5), # top/bottom points
	Vector3(0, -side / 2, 0.5), # top/bottom points
	Vector3(side / 2, -0.5, 0), # left/right side points
	Vector3(0.5, 0, -side / 2), # front/back side point
	Vector3(-0.5, 0, -side / 2), # front/back side point
	Vector3(-side / 2, -0.5, 0) # left/right side points
]

var tilt: float = atan(1/ side)

func tilt_icosahedron(_ico: PoolVector3Array, angle: float) -> PoolVector3Array:
	for i in range(len(ico)):
		ico[i] = ico[i].rotated(Vector3(1, 0, 0), angle)
	return ico

var icosahedron = tilt_icosahedron(ico, -tilt)
