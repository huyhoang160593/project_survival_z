class_name QodotSpatial, 'res://addons/qodot/icons/icon_qodot_spatial.svg'
extends Spatial

export(int) var currentLevel = -1

var resource = preload('res://maps/level_dialogue.tres')

func _ready() -> void:
	match currentLevel:
		0:
			DialogueManager.show_example_dialogue_balloon('level_0',resource)
		1:
			DialogueManager.show_example_dialogue_balloon('level_1',resource)
		2:
			DialogueManager.show_example_dialogue_balloon('level_2', resource)
		3:
			DialogueManager.show_example_dialogue_balloon('level_3_enchance', resource)

func get_class() -> String:
	return 'QodotSpatial'

func _on_FinishArea_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.emit_signal('level_finished', true)

func _on_DieArea_body_entered(body: Node) -> void:
	if body is Player or body is Enemy:
		GameEvents.emit_signal('heart_decrease', body, 1000)

func _on_ActiveArea_body_exited(body: Node) -> void:
	DialogueManager.show_example_dialogue_balloon('level_3_find_key', resource)
