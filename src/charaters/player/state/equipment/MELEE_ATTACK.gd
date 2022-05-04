extends PlayerState

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	var error_code = GameEvents.connect('attack_finished', self,'on_attack_finished_handle')
	GameEvents.emit_signal('melee_attack_event')

func on_attack_finished_handle(weaponNode: Spatial) -> void:
	var currentWeaponNode = player.get_weapon_node(player.currentWeapon)
	if weaponNode != currentWeaponNode:
		return
	active_state_machine.transition_to(Constants.EquipStateDict[Constants.IDLE])

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	GameEvents.disconnect('attack_finished', self, 'on_attack_finished_handle')
