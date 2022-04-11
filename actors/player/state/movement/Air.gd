extends PlayerState

var state_machine_type: StateMachine = null

func enter(msg := {}) -> void:
	if(state_machine is StateMachine):
		state_machine_type = state_machine as StateMachine
	if msg.has("do_jump"):
		# TODO: make jump action here
		player.velocity.y = player.jump_impulse
		pass

func physics_update(delta: float) -> void:
	var movement_vector: Vector3 = StaticHelper.get_movement_direction(player.transform.basis)
	
	# Make movement half when in the air
	player.velocity.x = movement_vector.x * (player.speed / 2)
	player.velocity.z = movement_vector.z * (player.speed / 2)
	
	# Gravity apply
	player.velocity.y -= player.gravity * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)
	
	# Landing
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z, 0.0):
			state_machine_type.transition_to(listPlayerState[IDLE])
		else:
			state_machine_type.transition_to(listPlayerState[MOVE])
