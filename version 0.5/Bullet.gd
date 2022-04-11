extends Area

var speed: float = 30.0
var damage : int = 1

func _process(delta):
	
	# move the bullet forwards
	translation += global_transform.basis.z * speed * delta


func _on_Bullet_body_entered(body: Object) -> void:
	# does this body have a 'take_damage' function?
	# if so, deal damage and destroy the bullet
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
	pass # Replace with function body.

func destroy() -> void:
	queue_free()
