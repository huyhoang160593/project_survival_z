extends CSGMesh
class_name ShieldWall

onready var wallAnimaion = $AnimationPlayer

func active_collistion() -> void:
	self.use_collision = true

func on_wall_break() -> void:
	wallAnimaion.play('FadeOut')
	yield(wallAnimaion,'animation_finished')
	queue_free()
