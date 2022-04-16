extends PlayerState

var timePass: float

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		# TODO: make jump action here
		player.velocity.y = player.jump_impulse

func physics_update(delta: float) -> void:
	timePass += delta
	var movement_vector: Vector3 = StaticHelper.get_movement_direction(player.transform.basis)
	
	# Make movement half when in the air
	player.velocity.x = movement_vector.x * (player.speed / 2)
	player.velocity.z = movement_vector.z * (player.speed / 2)
	
	# Gravity apply
	player.velocity.y -= (player.gravity + player.gravity * timePass) * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)
	
	# Landing
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z, 0.0):
			active_state_machine.transition_to(listPlayerState[IDLE])
		else:
			active_state_machine.transition_to(listPlayerState[MOVE])

func exit() -> void:
	timePass = 0
