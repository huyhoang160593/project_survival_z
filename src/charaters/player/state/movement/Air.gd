extends PlayerState

var timePass: float
var jumpMovingSpeed: float

func enter(msg := {}) -> void:
	jumpMovingSpeed = player.speed / 2

	if msg.has("do_jump"):
		player.velocity.y = player.jump_impulse

func physics_update(delta: float) -> void:
	timePass += delta
	var movement_vector: Vector3 = StaticHelper.get_movement_direction(player.transform.basis)
	
	# Make movement half when in the air
	player.velocity.x = lerp(player.velocity.x, movement_vector.x * jumpMovingSpeed, player.acceleration * delta)
	player.velocity.z = lerp(player.velocity.z, movement_vector.z * jumpMovingSpeed, player.acceleration * delta)
	
	# Gravity apply
	player.velocity.y -= (player.gravity + player.gravity * timePass) * delta
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)
	
	# Landing
	if player.is_on_floor():
		active_state_machine.transition_to(Constants.MovingStateDict[Constants.MOVE])

func exit() -> void:
	timePass = 0
