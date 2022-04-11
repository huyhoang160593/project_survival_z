extends KinematicBody

#components
export(NodePath) onready var _player = get_node(_player) as KinematicBody
export(NodePath) onready var _timer = get_node(_timer) as Timer

#stats
var health : int = 5
var moveSpeed : float = 1.0

#attacking
var damage:int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0

var scoreToGive : int = 10

func _ready():
	#setup timer
	_timer.wait_time = attackRate
	_timer.start()

func _physics_process(delta):
	
	# calculate direction to the player
	var dir = (_player.translation - translation).normalized()
	dir.y = 0
	
	# move the enemy towards the player
	move_and_slide(dir * moveSpeed, Vector3.UP)
	
func take_damage(damage):
	health -= damage
	
	# if we've ran out of health - die
	if health <= 0:
		die()

func die():
	_player.add_score(scoreToGive)
	queue_free()

func attack():
	_player.take_damage(damage)

# called every 'attackRate' seconds
func _on_Timer_timeout():
	
	# if we're at the right distance, attack the player
	if translation.distance_to(_player.translation) <= attackDist:
		attack()
	
