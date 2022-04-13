extends PlayerState

var ads_mode: bool = false

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if _msg.has("adsMode"):
		ads_mode = _msg["adsMode"]
	(player.crossHairNode as TextureRect).visible = false

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if Input.is_action_just_pressed('aim_down_sign'):
		ads_mode = not ads_mode
	if Input.is_action_just_pressed('shoot'):
		active_state_machine.transition_to(listEquipState[SHOOT], {prevState = AIM_DOWN_SIGN})
		
	var playerHand = player.hand as Spatial
	var playerCamera = player.camera as Camera
	
	transform_gun_position(ads_mode,playerHand,playerCamera, _delta)

	if is_equal_approx((playerHand.transform.origin - player.default_gun_position).length(), 0.0):
		active_state_machine.transition_to(listEquipState[IDLE])
	
func transform_gun_position(isInAdsMode: bool, playerHand: Spatial, playerCamera: Camera, delta: float) -> void:
	if isInAdsMode:
		playerHand.transform.origin = playerHand.transform.origin.linear_interpolate(player.ads_gun_position, player.ADS_LERP * delta)
		playerCamera.fov = lerp(playerCamera.fov, player.FOV_ADS, player.ADS_LERP * delta)
	else: 
		playerHand.transform.origin = playerHand.transform.origin.linear_interpolate(player.default_gun_position, player.ADS_LERP * delta)
		playerCamera.fov = lerp(playerCamera.fov, player.FOV_DEFAULT, player.ADS_LERP * delta)
