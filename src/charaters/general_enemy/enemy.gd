extends RigidBody
class_name Enemy

signal enemy_dead

enum Type {PUSHER, HEALER, GUNNER, WARRIOR, BOSS}

export(Type) var enemyType 
export(int, 0,15,1) var TURN_SPEED
export(int, 1,50,1) var damage
export(int, 0,15,1) var move_speed
export(int, 0,5000,5) var MAX_HEART
export(int, 0, 300) var push_distance

var target:Player

onready var body = $Body
onready var head = $Body/Head
onready var	rayCast = $Body/RayCast
onready var attackTimer = $AttackTimer
onready var bodyDetection = $BodyDetection

# Inherited Scene can't get node at onready so we need to do it in the _ready() function
export(NodePath) onready var modelAnimationPlayer
export(NodePath) onready var enemyEffect
export(NodePath) onready var currentWeapon

var current_heart := 0

func _ready() -> void:
	var error_code = GameEvents.connect('heart_decrease',self,"on_attacked_handle")
	StaticHelper.log_error_code(error_code, self.name)
	current_heart = MAX_HEART


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	$StateMachine.integrate_forces_rigidBody(state)

func on_attacked_handle(targetNode: Spatial, ammount: int) -> void:
	if targetNode != self:
		return
	if(enemyEffect is AnimationPlayer && !enemyEffect.is_playing()):
		enemyEffect.play("Hurt")
	current_heart = int(clamp(float(current_heart - ammount), 0.0, MAX_HEART))
	# enemy dead handle
	if current_heart == 0:
		bodyDetection.disabled = true
		move_speed = 0
		modelAnimationPlayer.play("Idle")
		if enemyEffect is AnimationPlayer: 
			enemyEffect.play("Dead")
			yield(enemyEffect,'animation_finished')
		emit_signal('enemy_dead')
		queue_free()

	match enemyType:
		Type.HEALER:
			yield(get_tree().create_timer(0.5),'timeout')
			current_heart = int(clamp(float(current_heart + ammount * 2), 0.0, 100.0))


func _on_AttackRange_body_entered(body: Node) -> void:
	print(enemyType," entered")
	if body is Player:
		match(enemyType):
			Type.PUSHER, Type.BOSS:
				var direction = target.global_transform.origin - global_transform.origin
				var pushVector = direction.normalized() * push_distance
				GameEvents.emit_signal('push_charater', pushVector)
		GameEvents.emit_signal('heart_decrease', body, damage)
