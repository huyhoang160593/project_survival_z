extends RigidBody

export(int, 5,100,5) var damage = 5 
export(float, 0, 10, .001) var speed

func _ready() -> void:
	set_as_toplevel(true)
	pass
	
func _physics_process(delta: float) -> void:
	apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Bullet_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
