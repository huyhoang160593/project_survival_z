extends DummyEnemyState

var player: Player = null
var enemyHead: Spatial = null

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	enemyHead = enemy.head

func _on_SightRange_body_entered(body: Node) -> void:
	if(body is Player):
		player = body
		(enemy.timer as Timer).start()
		move_to(player.global_transform.origin)

func _on_SightRange_body_exited(body: Node) -> void:
	if(body is Player):
		active_state_machine.transition_to(movementStates[IDLE])


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	enemyHead.look_at(player.global_transform.origin, Vector3.UP)
	print(enemyHead.rotation.y)
	enemy.rotate_y(deg2rad(enemyHead.rotation.y * enemy.TURN_SPEED))

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if enemy.path_node < enemy.path.size():
		var direction = (enemy.path[enemy.path_node] - enemy.global_transform.origin) as Vector3
		direction.y = 0
		if direction.length() < 1:
			enemy.path_node += 1
		else:
			var movementVector = direction.normalized() * enemy.speed
			movementVector.y -= enemy.gravity
			enemy.move_and_slide(movementVector, Vector3.UP)

func move_to(target_position: Vector3):
	enemy.path = (enemy.navigation as Navigation).get_simple_path(enemy.global_transform.origin, target_position)
	enemy.path_node = 0

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player = null


func _on_EnemyTimer_timeout() -> void:
	if player == null:
		return
	var isPlayerCollider := (enemy.rayCast as RayCast).get_collider() is Player
	if isPlayerCollider:
		GameEvents.emit_signal('heart_decrease', player, 30)
	
	move_to(player.global_transform.origin)
	(enemy.timer as Timer).start()
	
