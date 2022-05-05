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

static func add_spray_variation(variation_vector2: Vector2, normal_vector: Vector3) -> Vector3:
	match normal_vector:
		Vector3.LEFT,Vector3.RIGHT:
			return Vector3(0, variation_vector2.x, variation_vector2.y)
		Vector3.UP,Vector3.DOWN:
			return Vector3(variation_vector2.x, 0, variation_vector2.y)
	return Vector3(variation_vector2.x, variation_vector2.y, 0)

static func is_in_right_position(playerHandTransformOrigin: Vector3, playerHandPositionFixed: Vector3) -> bool:
	if is_equal_approx((playerHandTransformOrigin - playerHandPositionFixed).length(), 0.0):
		return true
	return false
	
static func log_error_code(errorCode: int, nodeName: String) -> void:
	if errorCode == 0:
		return
	print_debug("ERROR connect in ", nodeName ," with code: ", errorCode)
	pass
