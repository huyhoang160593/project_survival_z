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

export(int, 5,30,5) var damage
export(int, 1, 30) var ammoSize
export(int, 0, 250) var capacity
export(float, 0.0, 5.0) var reloadTime
var remainAmmo:int
var currentAmmo:int

var heatValue = recoilArrays.size()


func _ready() -> void:
	randomize()
	currentAmmo = int(rand_range(0.0, float(ammoSize)))
	remainAmmo = int(rand_range(float(capacity) / 2, float(capacity)))
	
	var error_code = GameEvents.connect('gun_shot_event', self, "_on_gun_shot_event_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('weapon_change_success', self, "_on_weapon_change_success_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('reload_finished', self, "_on_reload_finished_handle")
	StaticHelper.log_error_code(error_code, self.name)
	
func _on_gun_shot_event_handle(playerRaycast: RayCast):
	if shootingType == ShootingType.BURST and self.visible:
		if currentAmmo > 0:
			_shoot_bullet(playerRaycast)
	elif shootingType == ShootingType.SINGLE and self.visible:
		if currentAmmo > 0:
			_shoot_bullet(playerRaycast)
			GameEvents.emit_signal('attack_finished')

func _shoot_bullet(playerRaycast: RayCast) -> void:
	if not animationPlayer.is_playing():
		_create_bullet(playerRaycast)
		_add_heat_value()
		_decrease_ammo()
	animationPlayer.play(GUN_SHOT_ANIMATION)

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

func _on_weapon_change_success_handle(weaponNode: Spatial) -> void:
	if weaponNode == self:
		GameEvents.emit_signal('update_ammo_value', currentAmmo, remainAmmo)

func _decrease_ammo() -> void:
	currentAmmo -= 1
	GameEvents.emit_signal('update_ammo_value', currentAmmo, remainAmmo)

func _on_reload_finished_handle(weaponNode: Spatial) -> void:
	if weaponNode != self:
		return
	var ammoNeed = ammoSize - currentAmmo
	if remainAmmo - ammoNeed < 0:
		currentAmmo += remainAmmo
		remainAmmo = 0
	else:
		currentAmmo = ammoSize
		remainAmmo -= ammoNeed
	GameEvents.emit_signal('update_ammo_value', currentAmmo, remainAmmo)

func _on_HeatTimer_timeout() -> void:
	if heatValue > 0:
		heatValue -= 1
		heatTimer.start()
