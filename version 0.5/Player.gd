extends KinematicBody

#Player component
export(NodePath) onready var _camera = get_node(_camera) as Camera 
export(NodePath) onready var _muzzle = get_node(_muzzle) as Spatial
onready var _bulletScene = preload("res://version 0.5/Bullet.tscn")
export(NodePath) onready var _ui = get_node(_ui) as Control

#stat
var currentHP:int = 10
var maxHP:int = 10
var ammo:int = 15
var score:int = 0

#physics
var moveSpeed: float = 5.0
var jumpForce: float = 5.0
var gravity: float = 9.8

#camera look
const MIN_LOOK_ANGLE: float = -90.0
const MAX_LOOK_ANGLE: float = 90.0
export var lookSensitivity: float = 1.0

#vectors
var velocity: Vector3 = Vector3()
var mouseDelta: Vector2 = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set the UI
	_ui.update_health_bar(currentHP, maxHP)
	_ui.update_ammo_text(ammo)
	_ui.update_score_text(score)

func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	
	#rotate camera along X axis
	_camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta
	
	#clamp the vertical camera rotation
	_camera.rotation_degrees.x = clamp(_camera.rotation_degrees.x, MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
	
	#rotate player body along Y axis
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	
	#reset the mouse delta vector
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

# called every physics step
func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	
	var input := Vector2()
	
	#movement inputs
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	
	#normalize the input so we can't move faster diagonally
	input = input.normalized()
	
	#get our forward and right directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	#set the veloctity
	velocity.z = (forward * input.y + right * input.x).z * moveSpeed
	velocity.x = (forward * input.y + right * input.x).x * moveSpeed
	
	#apply gravity
	velocity.y -= gravity * delta
	
	#move the player
	velocity = move_and_slide(velocity,Vector3.UP)
	
	#jump if we press the jump button and we are standing on the floor
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
		
func shoot() -> void:
	var bullet = _bulletScene.instance()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_transform = _muzzle.global_transform
	bullet.scale = Vector3.ONE
	
	ammo -=1
	_ui.update_ammo_text(ammo)
	
# called when an enemy damages us
func take_damage(damage):
	currentHP -= damage
	if currentHP <= 0:
		currentHP = 0
		die()
	_ui.update_health_bar(currentHP, maxHP)
# called when our health reaches 0
func die():
	pass
	
# called when we kill an enemy
func add_score(amount):
	score += amount
	_ui.update_score_text(score)
	
# adds an amount of health to the player
func add_health(amount):
	currentHP = clamp(currentHP + amount, 0 , maxHP)
	
# adds an amount of ammo to the player
func add_ammo(amount):
	ammo += amount
	_ui.update_ammo_text(ammo)
