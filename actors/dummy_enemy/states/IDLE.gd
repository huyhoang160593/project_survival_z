extends DummyEnemyState	
	
func _on_SightRange_body_entered(body: Node) -> void:
	if body is Player:
		active_state_machine.transition_to(movementStates[ALERT])


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass


