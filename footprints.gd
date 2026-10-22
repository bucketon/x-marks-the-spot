extends Node3D

var next = 0
var footprints: Array[Node3D]

func _ready():
	for N in get_children():
		footprints.append(N)

func placeFootprint(loc:Vector2, rot:Vector3):
	footprints[next].global_position = Vector3(loc.x, 0.51, loc.y)
	footprints[next].rotation.y = rot.y
	next += 1
	if next >= footprints.size():
		next = 0
