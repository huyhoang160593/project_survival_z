class_name DummyEnemy
extends Spatial

export(int, 0,15,1) var TURN_SPEED

export(NodePath) onready var rayCast = get_node(rayCast) as RayCast

export(NodePath) onready var head = get_node(head) as Spatial
