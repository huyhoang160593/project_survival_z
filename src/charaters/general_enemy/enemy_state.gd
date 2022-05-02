extends State
class_name EnemyState

enum { IDLE, ALERT }
var stateDict = {
	IDLE: "IDLE",
	ALERT: "ALERT"
}

# Typed reference to the DummyEnemy node.
var enemy: Enemy

# Typed reference to the state machine node.
var active_state_machine: StateMachine

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	enemy = owner as Enemy
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(enemy != null)
	
# Override this function to pass state_machine to active_state_machine for autocomplete, and we will use that in the child classes and call enter so the child node don't need to override this
func before_enter(msg := {}) -> void:
	active_state_machine = state_machine
	enter(msg)
