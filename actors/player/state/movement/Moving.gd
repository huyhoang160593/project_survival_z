extends PlayerState

var state_machine_type: StateMachine = null

func enter(_msg:={}) -> void:
	if(state_machine is StateMachine):
		state_machine_type = state_machine as StateMachine

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine_type.transition_to(listPlayerState[AIR])
		return
	movement_process(delta)
	
	if Input.is_action_just_pressed("jump"):
		state_machine_type.transition_to(listPlayerState[AIR], {do_jump = true})
	
	if is_equal_approx(player.velocity.x, 0.0) \
		and is_equal_approx(player.velocity.z, 0.0):
			state_machine_type.transition_to(listPlayerState[IDLE])
	
func movement_process(delta: float) -> void:
	var movement_vector: Vector3 = StaticHelper.get_movement_direction(player.transform.basis)
	
	# Make movement slowly accelerate up and down
	player.velocity.x = lerp(player.velocity.x, movement_vector.x * player.speed, player.acceleration * delta)
	player.velocity.z = lerp(player.velocity.z, movement_vector.z * player.speed, player.acceleration * delta)
	# Gravity apply
	var gravity_resistance = player.get_floor_normal() if player.is_on_floor() else Vector3.UP
	player.velocity -= gravity_resistance * player.gravity
#	player.velocity.y -= player.gravity * delta
	# Moving charater base on the velocity calculated
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)
	
