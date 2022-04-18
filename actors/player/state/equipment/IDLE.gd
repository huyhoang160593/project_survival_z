extends PlayerState

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	(player.crossHairNode as TextureRect).visible = true

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if _check_melee_input_requirement():
		active_state_machine.transition_to(listEquipState[MELEE_ATTACK])
	elif _check_shoot_input_requirement():
		active_state_machine.transition_to(listEquipState[SHOOT], {prevState = IDLE})
	elif _check_ads_input_requirement():
		active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN], {adsMode = true})
	elif _check_reload_input_requirement():
		active_state_machine.transition_to(listEquipState[RELOAD_AMMO])
	elif Input.is_action_just_pressed('main_weapon'):
		active_state_machine.transition_to(listEquipState[CHANGE_WEAPON], {weaponIndex = Weapon.MAIN})
	elif Input.is_action_just_pressed('second_weapon'):
		active_state_machine.transition_to(listEquipState[CHANGE_WEAPON], {weaponIndex = Weapon.SECOND})
	elif Input.is_action_just_pressed('melee_weapon'):
		active_state_machine.transition_to(listEquipState[CHANGE_WEAPON], {weaponIndex = Weapon.MELEE})

func _check_melee_input_requirement() -> bool:
	return Input.is_action_just_pressed('attack') \
		and player.currentWeapon == Weapon.MELEE

func _check_shoot_input_requirement() -> bool:
	return Input.is_action_just_pressed('attack') \
		and StaticHelper.is_in_right_position(player.hand.transform.origin, player.default_gun_position) \
		and player.currentWeapon != Weapon.MELEE

func _check_ads_input_requirement() -> bool:
	return Input.is_action_just_pressed('aim_down_sign') and player.currentWeapon != Weapon.MELEE

func _check_reload_input_requirement() -> bool:
	return Input.is_action_just_pressed('reload_ammo') and player.currentWeapon != Weapon.MELEE
