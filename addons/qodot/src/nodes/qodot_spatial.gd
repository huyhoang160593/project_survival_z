class_name QodotSpatial, 'res://addons/qodot/icons/icon_qodot_spatial.svg'
extends Spatial

func get_class() -> String:
	return 'QodotSpatial'


func _on_FinishArea_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.emit_signal('level_finished', true)


func _on_DieArea_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.emit_signal('level_finished', false)
