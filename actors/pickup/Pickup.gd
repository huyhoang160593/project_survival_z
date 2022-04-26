extends Area
class_name ItemPickup

enum WeaponEnum{ NONE, SHOTGUN, PISTOL, MACHINE_GUN, KNIFE}

export(Constants.ItemType) var itemType

export(WeaponEnum) var WeaponPickup
var weaponScene
var weaponInstance: Spatial = null
var weaponType := -1

func _enter_tree() -> void:
	if !itemType == Constants.ItemType.WEAPON:
		return
	if WeaponPickup == WeaponEnum.SHOTGUN:
		weaponScene = load('res://actors/weapons/hit_scan/Shotgun.tscn') as PackedScene
		weaponType = Constants.Weapon.MAIN
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.MACHINE_GUN:
		weaponScene = load('res://actors/weapons/projectile/MachineGun.tscn') as PackedScene
		weaponType = Constants.Weapon.MAIN
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.PISTOL:
		weaponScene = load('res://actors/weapons/projectile/PistolGun.tscn') as PackedScene
		weaponType = Constants.Weapon.SECOND
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.KNIFE:
		weaponScene = load('res://actors/weapons/melee/Knife.tscn') as PackedScene
		weaponType = Constants.Weapon.MELEE
		weaponInstance = weaponScene.instance()

func _ready() -> void:
	$AnimationPlayer.play('bobbing')
	pass


func _on_Pickup_player_entered(body: Node) -> void:
	if not body is Player:
		return
	if(itemType == Constants.ItemType.WEAPON and weaponType == -1):
		print("pickup weapon type not set")
	GameEvents.emit_signal('pick_up_item', itemType, body, weaponInstance, weaponType)
	queue_free()
