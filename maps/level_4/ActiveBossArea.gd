extends Area

onready var glassBox = $GlassBox

func _on_ActiveBossArea_body_entered(body: Node) -> void:
	if not body is Player:
		return
	glassBox.use_collision = true
	(glassBox.material as ShaderMaterial).set_shader_param("Color", Color( 0, 1, 0, 0.6 ))


func _on_The_Boss_enemy_dead() -> void:
	glassBox.use_collision = false
	(glassBox.material as ShaderMaterial).set_shader_param("Color", Color( 0, 1, 0, 0.9 ))
	$FinishArea/CollisionShape.disabled = false
