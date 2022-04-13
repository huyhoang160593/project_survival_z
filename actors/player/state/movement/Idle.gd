extends PlayerState

func enter(_msg:={}) -> void:
	player.velocity = Vector3.ZERO

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		active_state_machine.transition_to(listPlayerState[AIR])
		return
	if Input.is_action_just_pressed("jump"):
		active_state_machine.transition_to(listPlayerState[AIR], {do_jump = true})
	elif _check_movement_input():
		active_state_machine.transition_to(listPlayerState[MOVE])
		
func _check_movement_input() -> bool:
	return Input.is_action_pressed("move_backward") \
	 or Input.is_action_pressed("move_forward") \
	 or Input.is_action_pressed("move_left") \
	 or Input.is_action_pressed("move_right")
