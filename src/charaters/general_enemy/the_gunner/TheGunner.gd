extends Enemy

func _ready() -> void:
	modelAnimationPlayer = get_node(modelAnimationPlayer)
	enemyEffect = get_node(enemyEffect)

	currentWeapon = get_node(currentWeapon)
	GameEvents.emit_signal('gunner_cheating', currentWeapon)
