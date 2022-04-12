extends DummyEnemyState

var state_machine_type: StateMachine = null
var player: Player = null
var enemyHead: Spatial = null

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if(state_machine is StateMachine):
		state_machine_type = state_machine as StateMachine
	enemyHead = enemy.head

func _on_SightRange_body_entered(body: Node) -> void:
	if(body is Player):
		player = body

func _on_SightRange_body_exited(body: Node) -> void:
	if(body is Player):
		state_machine_type.transition_to(movementStates[IDLE])

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	enemyHead.look_at(player.global_transform.origin, Vector3.UP)
	enemy.rotate_y(deg2rad(enemyHead.rotation.y * enemy.TURN_SPEED))
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player = null
