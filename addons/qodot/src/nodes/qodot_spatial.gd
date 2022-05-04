class_name QodotSpatial, 'res://addons/qodot/icons/icon_qodot_spatial.svg'
extends Spatial

export(int) var currentLevel

var resource = preload('res://maps/level_dialogue.tres')

func _ready() -> void:
	match currentLevel:
		0:
			DialogueManager.show_example_dialogue_balloon('welcome_to_project_loop',resource)
		1:
			DialogueManager.show_example_dialogue_balloon('the_jump_of_belive',resource)
		2: 
			DialogueManager.show_example_dialogue_balloon('the_pusher_appear', resource)

func get_class() -> String:
	return 'QodotSpatial'

func _on_FinishArea_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.emit_signal('level_finished', true)


func _on_DieArea_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.emit_signal('heart_decrease', body, 100)
