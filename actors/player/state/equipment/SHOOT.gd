extends PlayerState

var _prev_state: int = IDLE

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	var error_code = GameEvents.connect('attack_finished',self, 'on_gun_shot_finished_handle')
	StaticHelper.log_error_code(error_code, self.name)
	if _msg.has("prevState"):
		_prev_state = _msg["prevState"]

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if Input.is_action_pressed('attack'):
		GameEvents.emit_signal('gun_shot_event', player.raycast)
	else: 
		GameEvents.emit_signal('attack_finished')
	
	
func on_gun_shot_finished_handle() -> void:
	match _prev_state:
		IDLE:
			active_state_machine.transition_to(listEquipState[IDLE])
		AIM_DOWN_SIGN:
			active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN])

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	GameEvents.disconnect('attack_finished',self, 'on_gun_shot_finished_handle')
