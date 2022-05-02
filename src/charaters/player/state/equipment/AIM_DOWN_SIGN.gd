extends PlayerState

var ads_mode: bool = false
var reload_weapon: bool = false
var weapon_index: int = -1

var playerHand: Spatial = null
var playerCamera: Camera = null

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	playerHand = player.hand as Spatial
	playerCamera = player.camera as Camera
	(player.crossHairNode as TextureRect).visible = false
	
	if _msg.has("adsMode"):
		ads_mode = _msg["adsMode"]
	


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if Input.is_action_just_pressed('aim_down_sign'):
		ads_mode = not ads_mode
	elif Input.is_action_just_pressed('main_weapon'):
		ads_mode = not ads_mode
		weapon_index = Constants.Weapon.MAIN
	elif Input.is_action_just_pressed('second_weapon'):
		ads_mode = not ads_mode
		weapon_index = Constants.Weapon.SECOND
	elif Input.is_action_just_pressed('melee_weapon'):
		ads_mode = not ads_mode
		weapon_index = Constants.Weapon.MELEE
	elif Input.is_action_just_pressed('reload_ammo'):
		ads_mode = not ads_mode
		reload_weapon = true
	if Input.is_action_just_pressed('attack') and StaticHelper.is_in_right_position(playerHand.transform.origin, player.ads_gun_position):
		active_state_machine.transition_to(Constants.EquipStateDict[Constants.SHOOT], {prevState = Constants.AIM_DOWN_SIGN})
	
	_transform_gun_position(ads_mode,playerHand,playerCamera, _delta)

	if StaticHelper.is_in_right_position(playerHand.transform.origin, player.default_gun_position):
		if reload_weapon:
			reload_weapon = false
			active_state_machine.transition_to(Constants.EquipStateDict[Constants.RELOAD_AMMO])
		elif weapon_index == -1:
			active_state_machine.transition_to(Constants.EquipStateDict[Constants.IDLE])
		else:
			active_state_machine.transition_to(Constants.EquipStateDict[Constants.CHANGE_WEAPON], {weaponIndex = weapon_index})
	
func _transform_gun_position(isInAdsMode: bool, player_hand: Spatial, player_camera: Camera, delta: float) -> void:
	if isInAdsMode:
		player_hand.transform.origin = player_hand.transform.origin.linear_interpolate(player.ads_gun_position, Constants.ADS_LERP * delta)
		player_camera.fov = lerp(player_camera.fov, Constants.FOV_ADS, Constants.ADS_LERP * delta)
	else: 
		player_hand.transform.origin = player_hand.transform.origin.linear_interpolate(player.default_gun_position, player.ADS_LERP * delta)
		player_camera.fov = lerp(player_camera.fov, Constants.FOV_DEFAULT, Constants.ADS_LERP * delta)
