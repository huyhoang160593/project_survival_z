extends PlayerState

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	var error_code = GameEvents.connect('attack_finished', self,'on_attack_finished_handle')
	GameEvents.emit_signal('melee_attack_event')

func on_attack_finished_handle() -> void:
	active_state_machine.transition_to(listEquipState[IDLE])

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	GameEvents.disconnect('attack_finished', self, 'on_attack_finished_handle')
