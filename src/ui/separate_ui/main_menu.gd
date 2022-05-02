extends Spatial

export(String, FILE) var levelZeroPath: String

func _on_StartButton_pressed() -> void:
	if levelZeroPath.length() == 0:
		printerr("level Zero not set path yet, please goto godot and set the path")
		return
	SceneChanger.goto_scene(levelZeroPath)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
