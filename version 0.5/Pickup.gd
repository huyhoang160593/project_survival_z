extends Area

enum PickupType {
	Health, Ammo
}

#stats
export(PickupType) var type = PickupType.Health
export var amount : int = 10

#bobbing
onready var startYPos : float = translation.y
var bobHeight : float = 1.0
var bobSpeed : float = 1.0
var bobbingUp : bool = true

func _process(delta):
	
	# move us up and down
	translation.y += (bobSpeed if bobbingUp else -bobSpeed) * delta
	
	# if we're at the top, start moving downwards
	if bobbingUp and translation.y > startYPos + bobHeight:
		bobbingUp = false
	# if we're at the bottom, start moving up
	elif !bobbingUp and translation.y < startYPos:
		bobbingUp = true

func _ready():
	pass


func _on_Pickup_body_entered(body):
	
	#did the player enter our collider?
	#if so give the stats and destroy the pickup
	if body.name == "Player":
		pickup(body)
		queue_free()

func pickup(player):
	match type:
		PickupType.Health:
			player.add_health(amount)
		PickupType.Ammo:
			player.add_ammo(amount)
