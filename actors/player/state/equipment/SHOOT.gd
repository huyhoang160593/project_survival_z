extends PlayerState

var _prev_state: int = IDLE

func _ready() -> void:
	GameEvents.connect('gun_shot_finished',self, "on_gun_shot_finished_handle")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if _msg.has("prevState"):
		_prev_state = _msg["prevState"]

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if Input.is_action_pressed('shoot'):
		GameEvents.emit_signal('gun_shot_event', player.raycast)
	else: 
		GameEvents.emit_signal('gun_shot_finished')
	
	
func on_gun_shot_finished_handle() -> void:
	match _prev_state:
		IDLE:
			active_state_machine.transition_to(listEquipState[IDLE])
		AIM_DOWN_SIGN:
			active_state_machine.transition_to(listEquipState[AIM_DOWN_SIGN])
