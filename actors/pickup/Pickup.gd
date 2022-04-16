extends Area
class_name ItemPickup

enum Type { NOTHING, HEART, AMMO }
export(Type) var itemType
export(int, 1,100,1) var ammount

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play('bobbing')


func _on_Pickup_body_entered(body: Node) -> void:
	if not body is Player:
		return
	match Type:
		Type.AMMO:
			pass
		Type.HEART:
			pass
	pass # Replace with function body.
