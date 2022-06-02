extends PlayerState

var timePass: float
var jumpMovingSpeed: float

var gravity_value := 0.0

var randomNumberGenerator: RandomNumberGenerator
var jumpSound: AudioStream = preload('res://assets/sounds/sfx/jump_sound.wav')

func enter(msg := {}) -> void:
	randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	
	jumpMovingSpeed = player.speed * 0.75

	if msg.has("do_jump"):
		GlobalSoundManager.play_sound(jumpSound, -10.0)
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
	if gravity_value > 0.47:
		var fall_damage := randomNumberGenerator.randfn(gravity_value - 0.1, 0.1) * 100
		fall_damage = floor(fall_damage)
		
		GameEvents.emit_signal('heart_decrease', player, fall_damage)
