extends PlayerState

var playerRaycast: RayCast = null

var _prev_state: int = IDLE

func _ready() -> void:
	GameEvents.connect('gun_shot_finished',self, "on_gun_shot_finished_handle")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	playerRaycast = player.raycast as RayCast
	if _msg.has("prevState"):
		_prev_state = _msg["prevState"]
	GameEvents.emit_signal('gun_shot_event', playerRaycast.get_collision_point(), playerRaycast.get_collision_normal())

# Virtual function. Corresponds to the `_physics_process()` callback.
#func physics_update(_delta: float) -> void:
#	var bulletInstance = bulletScene.instance()
#	playerMuzzle.add_child(bulletInstance)
#	bulletInstance.look_at(playerRaycast.get_collision_point(), Vector3.UP)
	
	
func on_gun_shot_finished_handle() -> void:
	match _prev_state:
		IDLE:
			active_state_machine.transition_to(listEquipState[IDLE])
		AIM_DOWN_SIGN:
			active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN])
