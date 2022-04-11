class_name Player
extends KinematicBody

const MIN_CAMERA_ANGLE = -60
const MAX_CAMERA_ANGLE = 85
const FOV_DEFAULT = 70
const FOV_ADS = 55
const ADS_LERP = 20

var isCaptureMouse = true

export(Vector3) var default_gun_position
export(Vector3) var ads_gun_position

export(float, 0, 1, 0.05) var camera_sensitivity = 0.05

export(float, 0, 15, 0.1) var gravity := 9.8
export(float, 0, 100, 0.5) var speed := 10.0
export(float, 0, 20, 0.1) var acceleration := 6.0
export(float, 0, 50, 0.5) var jump_impulse := 5.0

export(NodePath) onready var head = get_node(head) as Spatial
export(NodePath) onready var muzzle = get_node(muzzle)
export(NodePath) onready var raycast = get_node(raycast) as RayCast
export(NodePath) onready var hand = get_node(hand) as Spatial
export(NodePath) onready var camera = get_node(camera) as Camera
export(NodePath) onready var gunViewPort = get_node(gunViewPort) as Viewport
export(NodePath) onready var gunCamera = get_node(gunCamera) as Camera
export(NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer

#vectors
var velocity: Vector3 = Vector3.ZERO
var mouseDelta: Vector2 = Vector2.ZERO

func _ready():
	_toggle_capture_mouse_mode(isCaptureMouse)
	
func _input(event) -> void:
	if event.is_action_pressed('ui_cancel'):
		isCaptureMouse = not isCaptureMouse
		_toggle_capture_mouse_mode(isCaptureMouse)
	if isCaptureMouse:
		_aim(event)
	
func _process(delta: float) -> void:
	gunCamera.global_transform = camera.global_transform
	
func _aim(event: InputEvent) -> void:
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		rotate_y(deg2rad(-mouse_motion.relative.x * camera_sensitivity))
		head.rotate_x(deg2rad(-mouse_motion.relative.y * camera_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(MIN_CAMERA_ANGLE), deg2rad(MAX_CAMERA_ANGLE))

func _toggle_capture_mouse_mode(captureMouseFlag: bool) -> void:
	if captureMouseFlag:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_ViewportContainer_resized() -> void:
	if gunViewPort is Viewport:
		gunViewPort.size = get_viewport().size
