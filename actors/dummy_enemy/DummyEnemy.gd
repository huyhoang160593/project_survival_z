class_name DummyEnemy
extends KinematicBody

export(int, 0,15,1) var TURN_SPEED
export(int, 0,150,1) var currentHeart

var path = []
var path_node := 0
var speed := 3
var gravity := 9.8

export(NodePath) onready var navigation = get_node(navigation) as Navigation

export(NodePath) onready var rayCast = get_node(rayCast) as RayCast

export(NodePath) onready var head = get_node(head) as Spatial

onready var timer = $EnemyTimer

func _ready() -> void:
	var error_code = GameEvents.connect('heart_decrease', self, "on_attacked_handle")
	StaticHelper.log_error_code(error_code, self.name)

func on_attacked_handle(targetNode: Spatial, ammount: int) -> void:
	if targetNode != self:
		return
	currentHeart = int(clamp(float(currentHeart - ammount), 0.0, 100.0))
	if currentHeart == 0:
		queue_free()
