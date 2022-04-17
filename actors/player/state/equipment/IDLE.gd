extends PlayerState

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	(player.crossHairNode as TextureRect).visible = true

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if Input.is_action_just_pressed('shoot') and StaticHelper.is_in_right_position(player.hand.transform.origin, player.default_gun_position):
		active_state_machine.transition_to(listEquipState[SHOOT], {prevState = IDLE})
	elif Input.is_action_just_pressed('aim_down_sign'):
		active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN], {adsMode = true})
