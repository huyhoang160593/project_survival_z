extends CSGMesh
class_name ShieldWall

onready var wallAnimaion = $AnimationPlayer

var wallBreakSound: AudioStream = preload('res://assets/sounds/sfx/glass_breaking_sound.wav')

func active_collistion() -> void:
	self.use_collision = true

func on_wall_break() -> void:
	wallAnimaion.play('FadeOut')
	yield(wallAnimaion,'animation_finished')
	
	var coroutine = GlobalSoundManager.play_3D_sound(wallBreakSound, self)

	queue_free()
