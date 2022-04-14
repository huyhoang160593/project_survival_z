extends RigidBody

export(int, 5, 40,5) var damage
export(float, 0, 4, .01) var speed

func _ready() -> void:
	set_as_toplevel(true)
	pass
	
func _physics_process(delta: float) -> void:
	apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Timer_timeout() -> void:
	queue_free()


func _on_BulletRealCollision_body_entered(body: Node) -> void:
	queue_free()
