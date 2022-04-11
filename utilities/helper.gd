extends Object
class_name StaticHelper

static func get_movement_direction(playerTranformBasis: Basis) -> Vector3:
	var movement_vector: Vector3
	var forward_movement: Vector3
	var sideways_movement: Vector3
	
	if Input.is_action_pressed("move_forward"):
		forward_movement = -playerTranformBasis.z
	elif Input.is_action_pressed("move_backward"):
		forward_movement = playerTranformBasis.z
		
	if Input.is_action_pressed("move_left"):
		sideways_movement = -playerTranformBasis.x
	elif Input.is_action_pressed("move_right"):
		sideways_movement = playerTranformBasis.x

	# Get the direction	
	movement_vector = forward_movement + sideways_movement
	return movement_vector.normalized()
