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

func _on_SightRange_body_exited(body: Node) -> void:
	if(body is Player):
		active_state_machine.transition_to(movementStates[IDLE])


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	enemyHead.look_at(player.global_transform.origin, Vector3.UP)
	enemy.rotate_y(deg2rad(enemyHead.rotation.y * enemy.TURN_SPEED))


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player = null
