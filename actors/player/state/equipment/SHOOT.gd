extends PlayerState

onready var bulletScene = preload('res://actors/Bullet.tscn')

var playerRaycast: RayCast = null
var playerMuzzle: Spatial = null
var playerCamera: Camera = null
var animationPlayer: AnimationPlayer = null

var state_machine_type: StateMachine = null
var _prev_state: int = IDLE

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	playerRaycast = player.raycast as RayCast
	playerMuzzle = player.muzzle as Spatial
	playerCamera = player.camera as Camera
	animationPlayer = player.animationPlayer as AnimationPlayer
	if(state_machine is StateMachine):
		state_machine_type = state_machine as StateMachine
	if _msg.has("prevState"):
		_prev_state = _msg["prevState"]
		

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var bulletInstance = bulletScene.instance()
	
	playerMuzzle.add_child(bulletInstance)
	bulletInstance.look_at(playerRaycast.get_collision_point(), Vector3.UP)
	animationPlayer.play(listAnimation[MACHINE_GUN_ANIMATION])
	
	match _prev_state:
		IDLE:
			state_machine_type.transition_to(listEquipState[IDLE])
		AIM_DOWN_SIGN:
			state_machine_type.transition_to(listEquipState[AIM_DOWN_SIGN])
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
