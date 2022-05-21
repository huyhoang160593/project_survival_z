extends Enemy

func _ready() -> void:
	modelAnimationPlayer = get_node(modelAnimationPlayer)
	enemyEffect = get_node(enemyEffect)
