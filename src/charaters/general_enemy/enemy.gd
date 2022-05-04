extends RigidBody
class_name Enemy

enum Type {PUSHER, HEALER, GUNNER, WARRIOR}

export(Type) var enemyType 
export(int, 0,15,1) var TURN_SPEED
export(int, 1,30,1) var damage
export(int, 0,15,1) var move_speed
export(int, 0,1000,5) var current_heart
export(int, 0, 100) var push_distance


var target:Player

onready var body = $Body
onready var head = $Body/Head
onready var	rayCast = $Body/RayCast
onready var attackTimer = $AttackTimer

# Inherited Scene can't get node at onready so we need to do it in the _ready() function
export(NodePath) onready var modelAnimationPlayer
export(NodePath) onready var currentWeapon

func _ready() -> void:
	var error_code = GameEvents.connect('heart_decrease',self,"on_attacked_handle")
	StaticHelper.log_error_code(error_code, self.name)


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	$StateMachine.integrate_forces_rigidBody(state)

func on_attacked_handle(targetNode: Spatial, ammount: int) -> void:
	if targetNode != self:
		return
	current_heart = int(clamp(float(current_heart - ammount), 0.0, 100.0))
	print("enemy lost heart", current_heart)
	# enemy dead handle
	if current_heart == 0:
		queue_free()

	match enemyType:
		Type.HEALER:
			yield(get_tree().create_timer(0.5),'timeout')
			current_heart = int(clamp(float(current_heart + ammount * 2), 0.0, 100.0))
