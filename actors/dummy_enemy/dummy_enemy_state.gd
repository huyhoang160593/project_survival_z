extends State
class_name DummyEnemyState

enum {IDLE, ALERT}
var movementStates = {
	IDLE: "IDLE",
	ALERT: "ALERT"
}

# Typed reference to the DummyEnemy node.
var enemy: DummyEnemy

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	enemy = owner as DummyEnemy
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(enemy != null)
