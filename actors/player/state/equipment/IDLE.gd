extends PlayerState

var state_machine_type: StateMachine = null

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if(state_machine is StateMachine):
		state_machine_type = state_machine as StateMachine

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
#	var playerHand = player.hand as Spatial
	
	if Input.is_action_just_pressed('shoot'):
		state_machine_type.transition_to(listEquipState[SHOOT], {prevState = IDLE})
	elif Input.is_action_just_pressed('aim_down_sign'):
		state_machine_type.transition_to(listEquipState[AIM_DOWN_SIGN], {adsMode = true})


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
