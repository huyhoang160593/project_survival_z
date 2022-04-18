extends PlayerState

var animationPlayer = null
var reloadTime:float = 0.0

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	animationPlayer = player.animationPlayer as AnimationPlayer
	
	var currentWeaponNode = _get_weapon_node(player.currentWeapon, player.hand)
	if currentWeaponNode is ProjectileGun or currentWeaponNode is Shotgun:
		reloadTime = currentWeaponNode.reloadTime
		
	animationPlayer.play('Hide-Show_Gun')
	
	yield(animationPlayer,'animation_finished')
	
	yield(get_tree().create_timer(reloadTime),'timeout')
	
	animationPlayer.play_backwards('Hide-Show_Gun')
	
	yield(animationPlayer,'animation_finished')
	
	GameEvents.emit_signal('reload_finished', currentWeaponNode)
	active_state_machine.transition_to(listEquipState[IDLE])


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

func _get_weapon_node(index: int, handNode: Spatial) -> Spatial:
	match index:
		Weapon.MAIN:
			if handNode.get_child(0).get_child_count() > 0:
				return (handNode.get_child(0).get_child(0) as Spatial)
		Weapon.SECOND:
			if handNode.get_child(1).get_child_count() > 0:
				return (handNode.get_child(1).get_child(0) as Spatial)
		Weapon.MELEE:
			if handNode.get_child(2).get_child_count() > 0:
				return (handNode.get_child(2).get_child(0) as Spatial)
	return null
