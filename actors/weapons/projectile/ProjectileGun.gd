extends MeshInstance
class_name ProjectileGun

const GUN_SHOT_ANIMATION := "gun_shot"
const MAX_VARIATION := 0.3
enum ShootingType { SINGLE, BURST }

onready var muzzle: Position3D = $Muzzle
onready var heatTimer: Timer = $HeatTimer

export(NodePath)onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export(ShootingType) var shootingType
export(PackedScene) onready var bulletScene: PackedScene
export var recoilArrays = PoolVector2Array()

var heatValue = recoilArrays.size()


func _ready() -> void:
	randomize()
	GameEvents.connect('gun_shot_event', self, "_on_gun_shot_event_handle")
	
func _on_gun_shot_event_handle(playerRaycast: RayCast):
	if shootingType == ShootingType.BURST:
		if not animationPlayer.is_playing():
			_create_bullet(playerRaycast)
			_add_heat_value()
		animationPlayer.play(GUN_SHOT_ANIMATION)
	elif shootingType == ShootingType.SINGLE:
		if not animationPlayer.is_playing():
			_create_bullet(playerRaycast)
			_add_heat_value()
		animationPlayer.play(GUN_SHOT_ANIMATION)
		GameEvents.emit_signal('gun_shot_finished')
		
func _create_bullet(playerRaycast: RayCast) -> void:
	var newCollisionPoint = playerRaycast.get_collision_point() \
		+ add_spray_variation(
			recoilArrays[heatValue] \
			+ Vector2(
				rand_range(MAX_VARIATION,-MAX_VARIATION), rand_range(MAX_VARIATION,-MAX_VARIATION)
			),
			playerRaycast.get_collision_normal()
		)
	var bulletInstance: ProjectileBullet = bulletScene.instance()
	bulletInstance.setup(newCollisionPoint, playerRaycast.get_collision_normal())
	muzzle.add_child(bulletInstance)
	
	bulletInstance.look_at(newCollisionPoint, Vector3.UP)
	
func add_spray_variation(variation_vector2: Vector2, normal_vector: Vector3) -> Vector3:
	match normal_vector:
		Vector3.LEFT,Vector3.RIGHT:
			return Vector3(0, variation_vector2.x, variation_vector2.y)
		Vector3.UP,Vector3.DOWN:
			return Vector3(variation_vector2.x, 0, variation_vector2.y)
	return Vector3(variation_vector2.x, variation_vector2.y, 0)

func _add_heat_value() -> void:
	if heatValue < recoilArrays.size() - 1:
		heatValue += 1
	heatTimer.start()

func _on_HeatTimer_timeout() -> void:
	if heatValue > 0:
		heatValue -= 1
		heatTimer.start()
