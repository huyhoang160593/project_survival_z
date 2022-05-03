extends PlayerState

var timePass: float
var jumpMovingSpeed: float

var gravity_value := 0.0

var randomNumberGenerator: RandomNumberGenerator

func enter(msg := {}) -> void:
	randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	
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
	gravity_value = (player.gravity + player.gravity * timePass) * delta
	player.velocity.y -= gravity_value
	player.velocity = player.move_and_slide(player.velocity, Vector3.UP)
	
	# Landing
	if player.is_on_floor():
		active_state_machine.transition_to(Constants.MovingStateDict[Constants.MOVE])

func exit() -> void:
	timePass = 0
	if gravity_value > 0.5:
		var fall_damage := randomNumberGenerator.randfn(0.4, 0.2) * 100
		GameEvents.emit_signal('heart_decrease', player, fall_damage)
