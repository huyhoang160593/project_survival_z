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
	var error_code = GameEvents.connect('gun_shot_event', self, "_on_gun_shot_event_handle")
	if error_code != 0:
		print_debug("ERROR: ", error_code)
	
func _on_gun_shot_event_handle(playerRaycast: RayCast):
	if shootingType == ShootingType.BURST and self.visible:
		if not animationPlayer.is_playing():
			_create_bullet(playerRaycast)
			_add_heat_value()
		animationPlayer.play(GUN_SHOT_ANIMATION)
	elif shootingType == ShootingType.SINGLE and self.visible:
		if not animationPlayer.is_playing():
			_create_bullet(playerRaycast)
			_add_heat_value()
		animationPlayer.play(GUN_SHOT_ANIMATION)
		GameEvents.emit_signal('gun_shot_finished')
		
func _create_bullet(playerRaycast: RayCast) -> void:
	var newCollisionPoint = playerRaycast.get_collision_point() \
		+ StaticHelper.add_spray_variation(
			_generated_new_spray_point(),
			playerRaycast.get_collision_normal()
		)
	var bulletInstance: ProjectileBullet = bulletScene.instance()
	bulletInstance.setup(newCollisionPoint, playerRaycast.get_collision_normal())
	muzzle.add_child(bulletInstance)
	
	bulletInstance.look_at(newCollisionPoint, Vector3.UP)
	
func _generated_new_spray_point() -> Vector2:
	if heatValue == 0:
		return recoilArrays[heatValue]
	elif heatValue < recoilArrays.size() - 1:
		return recoilArrays[heatValue] \
			+ Vector2(
				rand_range(MAX_VARIATION,-MAX_VARIATION), rand_range(MAX_VARIATION,-MAX_VARIATION)
			)
	return Vector2(
				rand_range(MAX_VARIATION,-MAX_VARIATION), rand_range(MAX_VARIATION,-MAX_VARIATION)
			)

func _add_heat_value() -> void:
	if heatValue < 100:
		heatValue += 1
	heatTimer.start()

func _on_HeatTimer_timeout() -> void:
	if heatValue > 0:
		heatValue -= 1
		heatTimer.start()
