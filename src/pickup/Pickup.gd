extends Area
class_name ItemPickup

enum WeaponEnum{ NONE, SHOTGUN, PISTOL, MACHINE_GUN, KNIFE}

export(Constants.ItemType) var itemType
export(WeaponEnum) var WeaponPickup

var weaponScene:PackedScene
var weaponInstance: Spatial = null
var weaponType := -1

func _enter_tree() -> void:
	if !itemType == Constants.ItemType.WEAPON:
		return
	if WeaponPickup == WeaponEnum.SHOTGUN:
		weaponScene = load('res://src/weapons/hit_scan/Shotgun.tscn') as PackedScene
		weaponType = Constants.Weapon.MAIN
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.MACHINE_GUN:
		weaponScene = load('res://src/weapons/projectile/MachineGun.tscn') as PackedScene
		weaponType = Constants.Weapon.MAIN
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.PISTOL:
		weaponScene = load('res://src/weapons/projectile/PistolGun.tscn') as PackedScene
		weaponType = Constants.Weapon.SECOND
		weaponInstance = weaponScene.instance()
	elif WeaponPickup == WeaponEnum.KNIFE:
		weaponScene = load('res://src/weapons/melee/Knife.gd') as PackedScene
		weaponType = Constants.Weapon.MELEE
		weaponInstance = weaponScene.instance()

func _ready() -> void:
	$AnimationPlayer.play('bobbing')
	var error_code = GameEvents.connect('pick_up_response',self, "on_pickup_response")
	StaticHelper.log_error_code(error_code, self.name)


func on_pickup_response(itemNode: Spatial, isSuccess: bool) -> void:
	if itemNode != self: 
		return
	if not isSuccess:
		print("This item can't be pickup")
		return
	queue_free()

func _on_Pickup_player_entered(body: Node) -> void:
	if not body is Player:
		return
	if itemType == Constants.ItemType.KEY:
		GameEvents.emit_signal('pick_up_key', self)
		return
	if(itemType == Constants.ItemType.WEAPON and weaponType == -1):
		print("pickup weapon type not set")
		return
	GameEvents.emit_signal('pick_up_item', self ,itemType, body, weaponInstance, weaponType)
