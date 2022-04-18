extends Spatial
class_name Shotgun

export(int, 5, 30, 5) var damage
export(int, 1, 30, 2) var spread

export(int, 1, 30) var ammoSize
export(int, 0, 250) var capacity
export(float, 0.0, 5.0) var reloadTime
var remainAmmo:int
var currentAmmo:int

export(PackedScene) onready var bulletDecal: PackedScene

onready var rayContainer = $RayContainer

func _ready() -> void:
	randomize()
	currentAmmo = int(rand_range(0.0, float(ammoSize)))
	remainAmmo = int(rand_range(float(capacity) / 2, float(capacity)))
	
	for ray in rayContainer.get_children():
		(ray as RayCast).cast_to.x = rand_range(spread, -spread)
		(ray as RayCast).cast_to.y = rand_range(spread, -spread)
	var error_code = GameEvents.connect('gun_shot_event', self,"_on_gun_shot_handle")
	StaticHelper.log_error_code(error_code,self.name)
	error_code = GameEvents.connect('weapon_change_success', self, "_on_weapon_change_success_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('reload_finished', self, "_on_reload_finished_handle")
	StaticHelper.log_error_code(error_code, self.name)
	
func _on_gun_shot_handle(_playerRaycast: RayCast) -> void:
	if not $AnimationPlayer.is_playing() and self.visible:
		fire_shotgun()
	
func fire_shotgun() -> void:
	if currentAmmo == 0:
		return
	_decrease_ammo()
	
	$AnimationPlayer.play('gun_shot')
	for ray in rayContainer.get_children():
		var rayTyped: RayCast = ray
		rayTyped.cast_to.x = rand_range(spread, -spread)
		rayTyped.cast_to.y = rand_range(spread, -spread)
		if not rayTyped.is_colliding():
			continue
		var decalInstance: Spatial = bulletDecal.instance()
		rayTyped.get_collider().add_child(decalInstance)
		decalInstance.global_transform.origin = rayTyped.get_collision_point()

		# Check ray collision_normal vector to make sure the bullet look at right "up" vector at look_at() function
		# The "up" vector should be LEFT or RIGHT when the decal is in the ground or in the ceiling
		var lookAtPosition: Vector3 = rayTyped.get_collision_point() + rayTyped.get_collision_normal()
		if rayTyped.get_collision_normal() == Vector3.UP or rayTyped.get_collision_normal() == Vector3.DOWN:
			decalInstance.look_at(lookAtPosition, Vector3.RIGHT)
		else:
			decalInstance.look_at(lookAtPosition, Vector3.UP)

	yield($AnimationPlayer,'animation_finished')
	GameEvents.emit_signal('attack_finished')

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
