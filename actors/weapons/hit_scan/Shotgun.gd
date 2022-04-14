extends Spatial

export(int, 5, 50, 5) var damage
export(int, 1, 30, 2) var spread

export(PackedScene) onready var bulletDecal: PackedScene

onready var rayContainer = $RayContainer

func _ready() -> void:
	randomize()
	for ray in rayContainer.get_children():
		(ray as RayCast).cast_to.x = rand_range(spread, -spread)
		(ray as RayCast).cast_to.y = rand_range(spread, -spread)
	GameEvents.connect('gun_shot_event', self,"_on_gun_shot_handle")
	
func _on_gun_shot_handle() -> void:
	fire_shotgun()
	
func fire_shotgun() -> void:
	$AnimationPlayer.play('gun_shot')
	for ray in rayContainer.get_children():
		var rayTyped: RayCast = ray
		rayTyped.cast_to.x = rand_range(spread, -spread)
		rayTyped.cast_to.y = rand_range(spread, -spread)
		if not rayTyped.is_colliding():
			continue
		var decalInstance: Spatial = bulletDecal.instance()
		rayTyped.get_collider().add_child(decalInstance)
		decalInstance.global_transform.origin = rayTyped.get_collision_point()

		# Check ray collision_normal vector to make sure the bullet look at right "up" vector at look_at() function
		# The "up" vector should be LEFT or RIGHT when the decal is in the ground or in the ceiling
		if rayTyped.get_collision_normal() == Vector3.UP or rayTyped.get_collision_normal() == Vector3.DOWN:
			decalInstance.look_at(rayTyped.get_collision_point() + rayTyped.get_collision_normal(), Vector3.RIGHT)
		else:
			decalInstance.look_at(rayTyped.get_collision_point() + rayTyped.get_collision_normal(), Vector3.UP)

	yield($AnimationPlayer,'animation_finished')
	GameEvents.emit_signal('gun_shot_finished')
	
