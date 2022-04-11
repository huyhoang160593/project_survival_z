# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends State

# Typed reference to the player node.
var player: Player

enum { IDLE, AIR, MOVE, SHOOT, AIM_DOWN_SIGN }
enum { MACHINE_GUN_ANIMATION }
var listPlayerState = {
	IDLE: "IDLE",
	AIR: "AIR",
	MOVE: "MOVE",
}
var listEquipState = {
	IDLE: "IDLE",
	SHOOT: "SHOOT",
	AIM_DOWN_SIGN: "AIM_DOWN_SIGN"
}

#Check list animation in the AnimationPlayer of Player Node
var listAnimation = {
	MACHINE_GUN_ANIMATION: "MachineGunFire"
}

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	player = owner as Player
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)
