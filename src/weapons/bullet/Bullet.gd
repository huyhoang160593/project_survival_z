extends RigidBody
class_name ProjectileBullet

export(int, 5, 40,5) var damage
export(float, 0, 4, .01) var speed

var bulletDecal: PackedScene = preload('res://src/weapons/misc/BulletDecal.tscn')

var collisionPointFromPlayer: Vector3
var collisionNormal: Vector3

func setup(collision_point: Vector3, collistion_normal: Vector3):
	collisionPointFromPlayer = collision_point
	collisionNormal = collistion_normal

func _ready() -> void:
	set_as_toplevel(true)
	
func _physics_process(_delta: float) -> void:
	apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Timer_timeout() -> void:
	queue_free()


func _on_BulletRealCollision_body_entered(body: Node) -> void:
	print(body)
	if body is Enemy or body is Player:
		GameEvents.emit_signal('heart_decrease', body, damage)
		queue_free()
		return

	if not _check_setup_variable():
		queue_free()
		return
	var decalInstance: Spatial = bulletDecal.instance()
	body.add_child(decalInstance)
	decalInstance.global_transform.origin = collisionPointFromPlayer
	var lookAtPosition: Vector3 = collisionPointFromPlayer + collisionNormal
	if collisionNormal == Vector3.UP or collisionNormal == Vector3.DOWN:
			decalInstance.look_at(lookAtPosition, Vector3.RIGHT)
	elif collisionNormal == Vector3.FORWARD or collisionNormal == Vector3.BACK:
		decalInstance.look_at(lookAtPosition, Vector3.UP)
	else:
		decalInstance.look_at(lookAtPosition, Vector3.FORWARD)
	queue_free()

func _check_setup_variable() -> bool:
	if collisionPointFromPlayer == null \
	 or collisionNormal == null:
		return false
	return true
