extends Enemy

func _ready() -> void:
	modelAnimationPlayer = get_node(modelAnimationPlayer)

	currentWeapon = get_node(currentWeapon)
	GameEvents.emit_signal('gunner_cheating', currentWeapon)
