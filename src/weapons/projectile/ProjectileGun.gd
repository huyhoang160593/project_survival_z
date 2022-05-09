extends MeshInstance
class_name ProjectileGun

export(PackedScene)onready var bulletScene: PackedScene

var machineGunSound: AudioStream = preload('res://assets/sounds/sfx/machine_gun_shot.wav')
var pistolGunSound: AudioStream = preload('res://assets/sounds/sfx/pistol_shot.wav')

const GUN_SHOT_ANIMATION := "gun_shot"
enum ShootingType { SINGLE, BURST }

onready var muzzle: Position3D = $Muzzle
onready var heatTimer: Timer = $HeatTimer

onready var bulletInstance: ProjectileBullet = bulletScene.instance()

export(NodePath)onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export(ShootingType) var shootingType
export var recoilArrays = PoolVector2Array()

export(float, 0.0, 3.0) var MAX_VARIATION
export(int, 5,30,5) var damage
export(int, 1, 30) var ammoSize
export(int, 0, 250) var capacity
export(float, 0.0, 5.0) var reloadTime

var remainAmmo:int
var currentAmmo:int

var heatValue = recoilArrays.size()

func _ready() -> void:
	randomize()
	#for testing
	currentAmmo = ammoSize
#	remainAmmo = int(rand_range(float(capacity) / 2, float(capacity)))
	
	var error_code = GameEvents.connect('gun_shot_event', self, "_on_gun_shot_event_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('weapon_change_success', self, "_on_weapon_change_success_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('reload_finished', self, "_on_reload_finished_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('gun_add_ammo', self,"_on_add_ammo_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('gunner_cheating', self, "_on_gunner_cheating_handle")
	
func _on_gun_shot_event_handle(raycast: RayCast, currentGunNode: Spatial, gunOwner: Spatial):
	if self != currentGunNode: 
		return
	if shootingType == ShootingType.BURST:
		if currentAmmo > 0:
			GlobalSoundManager.play_sound(machineGunSound)
			_shoot_bullet(raycast, gunOwner)
	elif shootingType == ShootingType.SINGLE:
		if currentAmmo > 0:
			GlobalSoundManager.play_sound(pistolGunSound)
			_shoot_bullet(raycast, gunOwner)
			GameEvents.emit_signal('attack_finished', currentGunNode)

func _shoot_bullet(raycast: RayCast, gunOwner: Spatial) -> void:
	if not animationPlayer.is_playing():
		_create_bullet(raycast, gunOwner)
		_add_heat_value()
		_decrease_ammo(gunOwner)
	animationPlayer.play(GUN_SHOT_ANIMATION)

func _create_bullet(raycast: RayCast, gunOwner: Spatial) -> void:
	var newCollisionPoint = raycast.get_collision_point() \
		+ StaticHelper.add_spray_variation(
			_generated_new_spray_point(gunOwner),
			raycast.get_collision_normal()
		)
	bulletInstance = bulletScene.instance()
	bulletInstance.setup(newCollisionPoint, raycast.get_collision_normal())
	muzzle.add_child(bulletInstance)
	
	bulletInstance.look_at(newCollisionPoint, Vector3.UP)
	
func _generated_new_spray_point(gunOwner: Spatial) -> Vector2:
	if gunOwner is Enemy:
		return Vector2(
				rand_range(MAX_VARIATION,-MAX_VARIATION), rand_range(MAX_VARIATION,-MAX_VARIATION)
			)
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
		GameEvents.emit_signal('update_ammo_ui', currentAmmo, remainAmmo)

func _decrease_ammo(gunOwner: Spatial) -> void:
	currentAmmo -= 1
	if gunOwner is Player:
		GameEvents.emit_signal('update_ammo_ui', currentAmmo, remainAmmo)

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
	GameEvents.emit_signal('update_ammo_ui', currentAmmo, remainAmmo)

func _on_add_ammo_handle(weaponNode: Spatial) -> void:
	if weaponNode == self:
		remainAmmo = int(clamp(remainAmmo + ammoSize * ceil(rand_range(0.0,3.0)),0,capacity))
		GameEvents.emit_signal('update_ammo_ui', currentAmmo, remainAmmo)

func _on_gunner_cheating_handle(weaponNode: Spatial) -> void:
	if weaponNode != self:
		return
	currentAmmo = 99999

func _on_HeatTimer_timeout() -> void:
	if heatValue > 0:
		heatValue -= 1
		heatTimer.start()
