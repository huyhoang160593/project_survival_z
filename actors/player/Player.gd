class_name Player
extends KinematicBody

const MIN_CAMERA_ANGLE = -60
const MAX_CAMERA_ANGLE = 85
const FOV_DEFAULT = 70
const FOV_ADS = 55
const ADS_LERP = 30
const MAX_HEART = 100

var isCaptureMouse = true

export(Constants.Weapon) var selectedWeapon
var previousWeapon = Constants.Weapon.NONE
var currentWeapon = Constants.Weapon.NONE



export(int, 0, 100) var currentHeart:int = MAX_HEART

export(Vector3) var default_gun_position
export(Vector3) var ads_gun_position

export(float, 0, 1, 0.05) var camera_sensitivity = 0.05

export(float, 0, 15, 0.1) var gravity := 9.8
export(float, 0, 100, 0.5) var speed := 10.0
export(float, 0, 20, 0.1) var acceleration := 6.0
export(float, 0, 50, 0.5) var jump_impulse := 5.0

export(NodePath) onready var head = get_node(head) as Spatial
export(NodePath) onready var raycast = get_node(raycast) as RayCast
export(NodePath) onready var hand = get_node(hand) as Spatial
export(NodePath) onready var camera = get_node(camera) as Camera
export(NodePath) onready var gunViewPort = get_node(gunViewPort) as Viewport
export(NodePath) onready var gunCamera = get_node(gunCamera) as Camera
export(NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export (NodePath) onready var crossHairNode = get_node(crossHairNode) as TextureRect

#vectors
var velocity: Vector3 = Vector3.ZERO
var mouseDelta: Vector2 = Vector2.ZERO

func _ready():
	var error_code = GameEvents.connect('heart_decrease',self,"on_heart_decrease_handle")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('pick_up_item', self, "on_pick_up_item_handle")
	gunViewPort.size = get_viewport().size
	GameEvents.emit_signal('update_heart_ui', currentHeart)

func _input(event) -> void:
	_aim(event)
	
func _process(_delta: float) -> void:
	gunCamera.global_transform = camera.global_transform

func _on_ViewportContainer_resized() -> void:
	if gunViewPort is Viewport:
		gunViewPort.size = get_viewport().size

func _aim(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * camera_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * camera_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(MIN_CAMERA_ANGLE), deg2rad(MAX_CAMERA_ANGLE))

#index belong to Weapon Enum, but we can't pass enum here so we will pass int instead
func get_weapon_node(weaponType: int, handNode: Spatial) -> Spatial:
	if weaponType > 2:
		return null
	if handNode.get_child(weaponType).get_child_count() > 0:
		return (handNode.get_child(weaponType).get_child(0) as Spatial)
	return null

func add_weapon(weaponType: int, weaponInstance: Spatial) -> void:
	hand.get_child(weaponType).add_child(weaponInstance)
	
func on_heart_decrease_handle(targetNode: Spatial, ammount: int) -> void:
	if targetNode != self:
		return
	currentHeart = int(clamp(float(currentHeart - ammount), 0.0, 100.0))
	GameEvents.emit_signal('update_heart_ui', currentHeart)
	
func on_pick_up_item_handle(itemType: int, playerNode: Spatial, weaponInstance: Spatial, weaponType: int) -> void:
	if itemType == Constants.ItemType.HEART:
		currentHeart = int(clamp(float(currentHeart + 30), 0.0, 100.0))
		GameEvents.emit_signal('update_heart_ui', currentHeart)
	elif itemType == Constants.ItemType.AMMO:
		GameEvents.emit_signal('gun_add_ammo',get_weapon_node(currentWeapon, hand))
	elif itemType == Constants.ItemType.WEAPON:
		if currentWeapon != Constants.Weapon.NONE:
			var currentWeaponNode = get_weapon_node(currentWeapon, hand)
			currentWeaponNode.visible = false
		add_weapon(weaponType, weaponInstance)
		currentWeapon = weaponType
		GameEvents.emit_signal('weapon_change_success', weaponInstance)
		
