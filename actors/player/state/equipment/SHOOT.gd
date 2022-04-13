extends PlayerState

onready var bulletScene = preload('res://actors/bullet/MachineGunBullet.tscn')

var playerRaycast: RayCast = null
var playerMuzzle: Spatial = null
var playerCamera: Camera = null
var animationPlayer: AnimationPlayer = null

var _prev_state: int = IDLE

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	playerRaycast = player.raycast as RayCast
	playerMuzzle = player.muzzle as Spatial
	playerCamera = player.camera as Camera
	animationPlayer = player.animationPlayer as AnimationPlayer
	if _msg.has("prevState"):
		_prev_state = _msg["prevState"]

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var bulletInstance = bulletScene.instance()
	
	playerMuzzle.add_child(bulletInstance)
	bulletInstance.look_at(playerRaycast.get_collision_point(), Vector3.UP)
	animationPlayer.play(listAnimation[MACHINE_GUN_ANIMATION])
	
	match _prev_state:
		IDLE:
			active_state_machine.transition_to(listEquipState[IDLE])
		AIM_DOWN_SIGN:
			active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN])
	pass
