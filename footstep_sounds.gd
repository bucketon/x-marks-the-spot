extends Node3D

var next = 1
var footstepSounds: Array[AudioStreamPlayer]
var rng = RandomNumberGenerator.new()

func _ready():
	for N in get_children():
		footstepSounds.append(N)
	

func playFootstepSound():
	var r = rng.randf_range(1, 7)
	footstepSounds[next*r].play()
	if next == 1:
		next = 2
	else:
		next = 1
	

func playFootstepSoundsRouter(pos:Vector2, rot:Vector3):
	playFootstepSound()
	
