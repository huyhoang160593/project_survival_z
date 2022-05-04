extends EnemyState

enum MINI_STATE { FOLLOW, ATTACK }

var currentState = MINI_STATE.FOLLOW

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	enemy.sleeping = false
	(enemy.attackTimer as Timer).start()

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if enemy.target == null:
		return
	(enemy.head as Spatial).look_at(enemy.target.global_transform.origin, Vector3.UP)
	(enemy.body as Spatial).rotate_y(deg2rad(enemy.head.rotation.y * enemy.TURN_SPEED))


# Virtual function. Corresponds to the `integrate_forces_rigidBody()` callback.
func integrate_forces_rigidBody(body_state: PhysicsDirectBodyState) -> void:
	match(currentState):
		MINI_STATE.FOLLOW:
			var direction = enemy.target.global_transform.origin - enemy.global_transform.origin
			var direction_vector = direction.normalized() * enemy.move_speed
			#apply gravity
			direction_vector.y -= 9.8
			body_state.linear_velocity = direction_vector

			if (direction_vector.x != 0 and direction_vector.z != 0):
				enemy.modelAnimationPlayer.play("Run")
		MINI_STATE.ATTACK:
			enemy.modelAnimationPlayer.play("Idle")
			body_state.linear_velocity = Vector3.ZERO


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	(enemy.attackTimer as Timer).stop()
	enemy.modelAnimationPlayer.play("Idle")

func _on_Area_body_exited(body: Node) -> void:
	if body is Player:
		enemy.target = null
		active_state_machine.transition_to(stateDict[IDLE])


func _on_AttackTimer_timeout() -> void:
	if (enemy.rayCast as RayCast).get_collider() is Player:
		match(enemy.enemyType):
			enemy.Type.HEALER:
				GameEvents.emit_signal('heart_decrease', enemy.rayCast.get_collider(), enemy.damage)
			enemy.Type.GUNNER:
				currentState = MINI_STATE.ATTACK
				GameEvents.emit_signal('gun_shot_event', enemy.rayCast, enemy.currentWeapon, enemy)
	else:
		currentState = MINI_STATE.FOLLOW
	(enemy.attackTimer as Timer).start()

func _on_AttackRange_body_entered(body: Node) -> void:
	if body is Player:
		match(enemy.enemyType):
			enemy.Type.PUSHER:
				var direction = enemy.target.global_transform.origin - enemy.global_transform.origin
				var pushVector = direction.normalized() * enemy.push_distance
				GameEvents.emit_signal('push_charater', pushVector)
		GameEvents.emit_signal('heart_decrease', body, enemy.damage)

