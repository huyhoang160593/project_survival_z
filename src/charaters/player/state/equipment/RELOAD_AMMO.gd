extends PlayerState

var animationPlayer = null
var reloadTime:float = 0.0

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	animationPlayer = player.animationPlayer as AnimationPlayer
	var currentWeaponNode = player.get_weapon_node(player.currentWeapon)
	
	if not _check_current_weapon_is_range(currentWeaponNode) \
		or currentWeaponNode.remainAmmo == 0:
		_back_to_idle_state()
		return
	reloadTime = currentWeaponNode.reloadTime
	animationPlayer.play('GunHide_Show')
	
	yield(animationPlayer,'animation_finished')
	yield(get_tree().create_timer(reloadTime),'timeout')
	animationPlayer.play_backwards('GunHide_Show')
	yield(animationPlayer,'animation_finished')
	GameEvents.emit_signal('reload_finished', currentWeaponNode)
	
	_back_to_idle_state()
	

func _back_to_idle_state() -> void:
	active_state_machine.transition_to(Constants.EquipStateDict[Constants.IDLE])

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
	
func _check_current_weapon_is_range(weaponNode: Node) -> bool:
	return weaponNode is ProjectileGun \
		or weaponNode is Shotgun
