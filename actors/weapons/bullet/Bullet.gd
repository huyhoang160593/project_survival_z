extends RigidBody
class_name ProjectileBullet

export(int, 5, 40,5) var damage
export(float, 0, 4, .01) var speed

export(PackedScene) onready var bulletDecal: PackedScene

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
	if not _check_setup_variable():
		print("The setup fall so there will be no bullet decal in this shot")
		queue_free()
		return
	var decalInstance: Spatial = bulletDecal.instance()
	body.add_child(decalInstance)
	decalInstance.global_transform.origin = collisionPointFromPlayer
	var lookAtPosition: Vector3 = collisionPointFromPlayer + collisionNormal
	if collisionNormal == Vector3.UP or collisionNormal == Vector3.DOWN:
		decalInstance.look_at(lookAtPosition, Vector3.RIGHT)
	else:
		decalInstance.look_at(lookAtPosition, Vector3.UP)
	queue_free()

func _check_setup_variable() -> bool:
	if collisionPointFromPlayer == null \
	 or collisionNormal == null:
		return false
	return true
