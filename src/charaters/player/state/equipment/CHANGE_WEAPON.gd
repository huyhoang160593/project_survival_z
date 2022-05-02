extends PlayerState

var weaponIndex: int = -1

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
		active_state_machine.transition_to(Constants.MovingStateDict[Constants.IDLE])
		return

	player.previousWeapon = player.currentWeapon
	player.currentWeapon = nextWeapon
	
	var previousWeaponNode: Spatial = player.get_weapon_node(player.previousWeapon)
	var currentWeaponNode: Spatial = player.get_weapon_node(player.currentWeapon)
	
	player.animationPlayer.play('GunHide_Show')
	
	yield(player.animationPlayer,'animation_finished')
	
	if previousWeaponNode != null:
		previousWeaponNode.visible = false
		
	player.animationPlayer.play_backwards('GunHide_Show')
	if currentWeaponNode != null:
		currentWeaponNode.visible = true
	
	GameEvents.emit_signal('weapon_change_success', currentWeaponNode)
	
	yield(player.animationPlayer,'animation_finished')
	
	active_state_machine.transition_to(Constants.EquipStateDict[Constants.IDLE])
	
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	weaponIndex = -1
