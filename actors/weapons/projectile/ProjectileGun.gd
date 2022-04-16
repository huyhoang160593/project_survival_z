extends MeshInstance
class_name ProjectileGun

const GUN_SHOT_ANIMATION = "gun_shot"
enum ShootingType { SINGLE, BURST }

onready var muzzle: Position3D = $Muzzle

export(NodePath)onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export(ShootingType) var shootingType
export(PackedScene) onready var bulletScene: PackedScene


func _ready() -> void:
	GameEvents.connect('gun_shot_event', self, "_on_gun_shot_event_handle")
	
func _on_gun_shot_event_handle(collision_point: Vector3, collision_normal: Vector3):
	$AnimationPlayer.play(GUN_SHOT_ANIMATION)

	var bulletInstance: ProjectileBullet = bulletScene.instance()
	bulletInstance.setup(collision_point, collision_normal)
	muzzle.add_child(bulletInstance)
	bulletInstance.look_at(collision_point, Vector3.UP)
	
	yield($AnimationPlayer,'animation_finished')
	GameEvents.emit_signal('gun_shot_finished')
