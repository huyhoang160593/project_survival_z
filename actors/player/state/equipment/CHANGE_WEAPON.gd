extends PlayerState

var weaponIndex: int

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(msg := {}) -> void:
	if msg.has("weaponIndex"):
		weaponIndex = msg["weaponIndex"]


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	_change_weapon_handle(weaponIndex)
	
func _change_weapon_handle(nextWeapon: int) -> void:
	if player.currentWeapon == nextWeapon:
		active_state_machine.transition_to(listEquipState[IDLE])
		return
	player.previousWeapon = player.currentWeapon
	player.currentWeapon = nextWeapon
	player.animationPlayer.play('Hide-Show_Gun')
	
	yield(player.animationPlayer,'animation_finished')
	
	var previousWeaponNode: Spatial = _get_weapon_node(player.previousWeapon, player.hand)
	var currentWeaponNode: Spatial = _get_weapon_node(player.currentWeapon, player.hand)
	
	if previousWeaponNode != null:
		previousWeaponNode.visible = false
		
	player.animationPlayer.play_backwards('Hide-Show_Gun')
	if currentWeaponNode != null:
		currentWeaponNode.visible = true
	
	GameEvents.emit_signal('weapon_change_success', currentWeaponNode)
	
	yield(player.animationPlayer,'animation_finished')
	
	active_state_machine.transition_to(listEquipState[IDLE])
	
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
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	weaponIndex = Weapon.NONE
